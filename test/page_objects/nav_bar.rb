# frozen_string_literal: true

module NavBarPageObject
  # Constants
  SIGN_OUT_BUTTON = 'Sign out'

  # Basic actions
  def click_sign_out_button
    click_on SIGN_OUT_BUTTON
  end
end
