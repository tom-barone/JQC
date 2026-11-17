# frozen_string_literal: true

module CookiesHelper
  SESSION_COOKIE = '_jqc_session'

  # Actions

  def delete_session_cookie
    # Deletes the session cookie stored in the browser.
    # Basically the same as clicking "Sign out" in the UI.
    # Used to test 'remember me' functionality.
    page.driver.browser.manage.delete_cookie(SESSION_COOKIE)
  end

  # The Cookie header a request needs to act as the user signed in to the browser.
  def session_cookie_header
    "#{SESSION_COOKIE}=#{page.driver.browser.manage.cookie_named(SESSION_COOKIE)[:value]}"
  end
end
