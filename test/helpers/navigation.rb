# frozen_string_literal: true

module NavigationHelper
  include SignInPageObject

  def visit_sign_in_page
    visit root_path # Assumes we haven't authenticated yet, will be redirected to sign in
  end

  def visit_home_page
    visit root_path # Assumes we are authenticated, will go to home page
  end

  # Convenience method for signing in with a test user
  def sign_in
    user = create(:user)
    visit_sign_in_page
    sign_in_with(user)
    assert_signed_in
  end

  def assert_signed_in
    assert_button NavBarPageObject::SIGN_OUT_BUTTON
  end

  def assert_signed_out
    assert_button SignInPageObject::SIGN_IN_BUTTON
  end
end
