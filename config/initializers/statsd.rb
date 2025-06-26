# frozen_string_literal: true

# Set default prefix if not provided
ENV['STATSD_PREFIX'] ||= 'jqc'

# Configuration for dokku-graphite
# We need to strip the 'statsd://' prefix if it exists
ENV['STATSD_ADDR'] = ENV.fetch('STATSD_URL', '127.0.0.1:8125').gsub(%r{^statsd://}, '')
