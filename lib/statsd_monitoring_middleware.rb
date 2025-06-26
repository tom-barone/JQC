# frozen_string_literal: true

class StatsdMonitoringMiddleware
  ASSET_TYPE_PATTERNS = [
    [/\.(css|scss)(\?|$)/, 'stylesheet'],
    [/\.(js|mjs)(\?|$)/, 'javascript'],
    [/\.(png|jpg|jpeg|gif|svg|ico|webp)(\?|$)/, 'image'],
    [/\.(woff|woff2|ttf|eot)(\?|$)/, 'font']
  ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    status, headers, response = @app.call(env)
    track_successful_request(env, status, start_time)

    [status, headers, response]
  rescue StandardError => e
    track_error_request(env, start_time)
    raise e
  end

  private

  def track_successful_request(env, status, start_time)
    duration_ms = calculate_duration(start_time)
    track_request_metrics(env, status, duration_ms)
  end

  def track_error_request(env, start_time)
    duration_ms = calculate_duration(start_time)
    track_request_metrics(env, 500, duration_ms)
  end

  def calculate_duration(start_time)
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ((end_time - start_time) * 1000).round(2)
  end

  def track_request_metrics(env, status, duration_ms)
    request = Rack::Request.new(env)
    tags = build_tags(env, request, status)

    StatsD.measure('http.request.duration', duration_ms, tags: tags)
    StatsD.increment('http.request.status', tags: tags)
  end

  def build_tags(env, request, status)
    tags = base_tags(status, request)
    tags.concat(controller_tags(env))
    tags.concat(request_type_tags(request))
  end

  def base_tags(status, request)
    [
      "status:#{status}",
      "method:#{request.request_method}"
    ]
  end

  def controller_tags(env)
    tags = []

    if env['action_controller.instance']
      add_instance_tags(tags, env['action_controller.instance'])
    elsif env['action_dispatch.request.path_parameters']
      add_param_tags(tags, env['action_dispatch.request.path_parameters'])
    end

    tags
  end

  def add_instance_tags(tags, controller_instance)
    tags << "controller:#{controller_instance.controller_name}"
    tags << "action:#{controller_instance.action_name}"
  end

  def add_param_tags(tags, params)
    return unless params[:controller] && params[:action]

    tags << "controller:#{params[:controller]}"
    tags << "action:#{params[:action]}"
  end

  def request_type_tags(request)
    if asset_request?(request.path)
      ['type:asset', asset_type_tag(request.path)]
    else
      ['type:application']
    end
  end

  def asset_type_tag(path)
    type = ASSET_TYPE_PATTERNS.find { |pattern, _| path.match?(pattern) }&.last || 'other'
    "asset_type:#{type}"
  end

  def asset_request?(path)
    path.start_with?('/assets/') ||
      path.match?(/\.(css|js|png|jpg|jpeg|gif|svg|ico|webp|woff|woff2|ttf|eot)(\?|$)/)
  end
end
