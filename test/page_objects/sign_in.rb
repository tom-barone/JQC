# frozen_string_literal: true

module SignInPageObject
  # Constants
  USERNAME_FIELD = 'Username'
  PASSWORD_FIELD = 'Password'
  REMEMBER_ME_CHECKBOX = 'Remember me'
  SIGN_IN_BUTTON = 'Sign in'

  def fill_username(username)
    fill_in USERNAME_FIELD, with: username
  end

  def fill_password(password)
    fill_in PASSWORD_FIELD, with: password
  end

  def check_remember_me
    check REMEMBER_ME_CHECKBOX
  end

  def uncheck_remember_me
    uncheck REMEMBER_ME_CHECKBOX
  end

  def click_sign_in_button
    click_on SIGN_IN_BUTTON
  end

  # Composite actions
  def sign_in_with_fields(username, password, remember_me: false)
    fill_username(username)
    fill_password(password)

    if remember_me
      check_remember_me
    else
      uncheck_remember_me
    end

    click_sign_in_button
  end

  def sign_in_with(user, remember_me: false)
    sign_in_with_fields(user.username, user.password, remember_me: remember_me)
  end
end
