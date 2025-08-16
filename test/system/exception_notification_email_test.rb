# frozen_string_literal: true

require 'application_system_test_case'

class ExceptionNotificationEmailTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  test 'Exception notification email is sent when an exception is raised' do
    emails = capture_emails do
      assert_raises(SyntaxError) do
        visit 'fail'
      end
    end

    assert_equal 1, emails.size

    email = emails.first

    assert_match(/I should send an exception notification email/, email.body.to_s)
  end
end
