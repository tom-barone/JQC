# frozen_string_literal: true

# Test user for development
if Rails.env.local? && User.find_by(username: 'test_user').nil?
  User.create!(
    email: 'test@email.com',
    username: 'test_user',
    password: 'h2&BUa0qvxoqTM^K', # use a password manager fools
    password_confirmation: 'h2&BUa0qvxoqTM^K'
  )
end

# Main user for production
email = Rails.application.credentials.jqc_email!
username = Rails.application.credentials.jqc_username!
if Rails.env.production? && User.find_by(username: username).nil?
  password = Rails.application.credentials.jqc_password!
  User.create!(
    email: email,
    username: username,
    password: password,
    password_confirmation: password
  )
end
