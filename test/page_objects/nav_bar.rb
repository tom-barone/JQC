# frozen_string_literal: true

module NavBarPageObject
  SIGN_OUT_BUTTON = 'Sign out'
  REQUEST_SUPPORT_BUTTON = 'Request Support'
  APPLICATIONS_LINK = 'Applications'
  BUILDING_SURVEYORS_LINK = 'Building Surveyors'
  REPORTS_LINK = 'Reports'
  SETTINGS_LINK = 'Settings'

  def click_sign_out_button
    click_on SIGN_OUT_BUTTON
  end

  def click_request_support_button
    click_on REQUEST_SUPPORT_BUTTON
  end

  def click_applications_link
    click_on APPLICATIONS_LINK
  end

  def click_building_surveyors_link
    click_on BUILDING_SURVEYORS_LINK
  end

  def click_reports_link
    click_on REPORTS_LINK
  end

  def click_settings_link
    click_on SETTINGS_LINK
  end
end
