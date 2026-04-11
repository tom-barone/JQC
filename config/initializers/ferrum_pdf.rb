# frozen_string_literal: true

FerrumPdf.configure do |config|
  config.process_timeout = 15
  config.browser_options = { 'no-sandbox': nil }
end

# Start the browser now so the first request doesn't pay the startup cost
FerrumPdf.with_browser { |b| b } # warm up
