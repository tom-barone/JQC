# frozen_string_literal: true

ENV['STATSD_PREFIX'] ||= 'jqc'
ENV['STATSD_IMPLEMENTATION'] ||= 'statsd'

# Configuration for dokku-graphite
# We need to strip the 'statsd://' prefix if it exists
ENV['STATSD_ADDR'] = ENV.fetch('STATSD_URL', '127.0.0.1:8125').gsub(%r{^statsd://}, '')
