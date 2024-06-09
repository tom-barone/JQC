# frozen_string_literal: true

# Integration Test
require 'test_helper'

class LastMonthCsvReportsTest < ActionDispatch::IntegrationTest
  test 'last month CSV reports are sent' do
    # Nothing is sent if the header is missing
    assert_emails 0 do
      get '/crons/last_month_csv_reports'
    end
    assert_emails 1 do
      get '/crons/last_month_csv_reports', headers: { 'X-Appengine-Cron' => true }
    end
    # Check email content
    email = ActionMailer::Base.deliveries.last
    assert email.to.include?('someone@email.com')
    assert email.subject.include?('JQC')
    assert email.body.encoded.include?('Test Person')
    assert email.body.encoded.include?('Please find the JQC monthly reports for')
    assert email.attachments.count == 4
  end
end
