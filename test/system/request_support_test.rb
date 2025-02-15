# frozen_string_literal: true

require 'application_system_test_case'
require 'helpers/sign_in_helper'

class RequestSupportTest < ApplicationSystemTestCase
  include SignInHelper

  test 'Request Support button shows the correct details' do
    sign_in_test_user

    support_email = Rails.application.credentials.support_email!
    support_phone = Rails.application.credentials.support_phone!
    support_name = "please contact #{Rails.application.credentials.support_name!}"

    click_on 'Request Support'
    assert_text support_email, exact: false
    assert_text support_phone, exact: false
    assert_text support_name, exact: false

    # Dismiss and check that the details are gone
    click_on 'Request Support'
    assert_no_text support_email, exact: false
    assert_no_text support_phone, exact: false
    assert_no_text support_name, exact: false
  end
end
