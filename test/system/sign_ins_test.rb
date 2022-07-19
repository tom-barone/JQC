# frozen_string_literal: true
require "application_system_test_case"

class SignInsTest < ApplicationSystemTestCase
   test "Before signing in, all URLs redirect to the login page" do
     visit root_path
     assert_text "Please sign in"

     visit applications_url
     assert_text "Please sign in"

     visit clients_url
     assert_text "Please sign in"
   end

   test "Logging into the system with correct credentials works" do
     visit root_path

     fill_in "Username", with: "test"
     fill_in "Password", with: "test_password"
     click_on "Sign in"

     assert_text "New Application"
   end

   test "Logging into the system with incorrect credentials fails" do
     visit root_path

     fill_in "Username", with: "test"
     fill_in "Password", with: "wrong_password"
     click_on "Sign in"

     assert_no_text "New Application"
     assert_text "Please sign in"
   end
end
