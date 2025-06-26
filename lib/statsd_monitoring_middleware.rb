# frozen_string_literal: true

module StatsdMonitoringHelpers
  ASSET_TYPE_PATTERNS = [
    [/\.(css|scss)(\?|$)/, 'stylesheet'],
    [/\.(js|mjs)(\?|$)/, 'javascript'],
    [/\.(png|jpg|jpeg|gif|svg|ico|webp)(\?|$)/, 'image'],
    [/\.(woff|woff2|ttf|eot)(\?|$)/, 'font']
  ].freeze

  def status_category(status)
    case status
    when 200..299 then '2xx'
    when 300..399 then '3xx'
    when 400..499 then '4xx'
    when 500..599 then '5xx'
    else 'other'
    end
  end

  def sanitize_metric_name(name)
    return 'unknown' if name.blank?

    # Replace invalid characters with underscores and convert to lowercase
    name.to_s.gsub(/[^a-zA-Z0-9_]/, '_').downcase
  end

  def asset_request?(path)
    path.start_with?('/assets/') ||
      path.match?(/\.(css|js|png|jpg|jpeg|gif|svg|ico|webp|woff|woff2|ttf|eot)(\?|$)/)
  end
end

class StatsdMonitoringMiddleware
  include StatsdMonitoringHelpers

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
    metric_context = build_metric_context(env, request, status)

    # Track duration with hierarchical metric names
    StatsD.measure("http.request.duration.#{metric_context[:base]}", duration_ms)
    StatsD.measure("http.request.duration.#{metric_context[:detailed]}", duration_ms)

    # Track request counts with hierarchical metric names
    StatsD.increment("http.request.count.#{metric_context[:base]}")
    StatsD.increment("http.request.count.#{metric_context[:detailed]}")

    # Track status-specific metrics
    StatsD.increment("http.request.status.#{status}")
    StatsD.increment("http.request.status.#{status_category(status)}")
  end

  def build_metric_context(env, request, status)
    method = sanitize_metric_name(request.request_method.downcase)
    status_cat = status_category(status)
    base_context = "#{method}.#{status_cat}"

    controller_info = extract_controller_info(env)
    request_type_info = extract_request_type_info(request)

    detailed_context = build_detailed_context(base_context, controller_info, request_type_info)

    {
      base: base_context,
      detailed: detailed_context
    }
  end

  def build_detailed_context(base_context, controller_info, request_type_info)
    if request_type_info[:is_asset]
      "#{base_context}.asset.#{request_type_info[:asset_type]}"
    else
      controller_part = build_controller_part(controller_info)
      "#{base_context}.app.#{controller_part}"
    end
  end

  def build_controller_part(controller_info)
    if controller_info[:controller]
      "#{controller_info[:controller]}.#{controller_info[:action]}"
    else
      'unknown'
    end
  end

  def extract_controller_info(env)
    extract_from_controller_instance(env) ||
      extract_from_path_parameters(env) ||
      { controller: nil, action: nil }
  end

  def extract_from_controller_instance(env)
    return nil unless env['action_controller.instance']

    instance = env['action_controller.instance']
    {
      controller: sanitize_metric_name(instance.controller_name),
      action: sanitize_metric_name(instance.action_name)
    }
  end

  def extract_from_path_parameters(env)
    return nil unless env['action_dispatch.request.path_parameters']

    params = env['action_dispatch.request.path_parameters']
    return nil unless params[:controller] && params[:action]

    {
      controller: sanitize_metric_name(params[:controller]),
      action: sanitize_metric_name(params[:action])
    }
  end

  def extract_request_type_info(request)
    if asset_request?(request.path)
      asset_type = ASSET_TYPE_PATTERNS.find { |pattern, _| request.path.match?(pattern) }&.last || 'other'
      { is_asset: true, asset_type: sanitize_metric_name(asset_type) }
    else
      { is_asset: false, asset_type: nil }
    end
  end
end
