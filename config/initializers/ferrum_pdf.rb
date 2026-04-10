# frozen_string_literal: true

FerrumPdf.configure do |config|
  config.process_timeout = 10
  config.browser_options = { 'no-sandbox': nil }
end
