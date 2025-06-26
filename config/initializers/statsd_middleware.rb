# frozen_string_literal: true

# Load and configure the StatsD monitoring middleware
require Rails.root.join('lib/statsd_monitoring_middleware')

Rails.application.config.middleware.insert_before(
  ActionDispatch::ShowExceptions,
  StatsdMonitoringMiddleware
)
