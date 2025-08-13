# frozen_string_literal: true

module CookiesHelper
  # Actions

  def delete_session_cookie
    # Deletes the session cookie stored in the browser.
    # Basically the same as clicking "Sign out" in the UI.
    # Used to test 'remember me' functionality.
    page.driver.browser.manage.delete_cookie('_jqc_session')
  end
end
