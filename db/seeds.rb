# frozen_string_literal: true

# Test user for development
if Rails.env.development? && User.find_by(username: 'test_user').nil?
  User.create!(
    email: 'test@email.com',
    username: 'test_user',
    password: 'h2&BUa0qvxoqTM^K', # use a password manager fools
    password_confirmation: 'h2&BUa0qvxoqTM^K'
  )
end

# Production users
email = Rails.application.credentials.jqc_email!
username = Rails.application.credentials.jqc_username!
if Rails.env.production? && User.find_by(username: username).nil?
  password = Rails.application.credentials.jqc_password!
  User.create!(
    email: email,
    username: username,
    password: password,
    password_confirmation: password,
    admin: false
  )
end

admin_email = Rails.application.credentials.admin_email!
admin_username = Rails.application.credentials.admin_username!
if Rails.env.production? && User.find_by(username: admin_username).nil?
  admin_password = Rails.application.credentials.admin_password!
  User.create!(
    email: admin_email,
    username: admin_username,
    password: admin_password,
    password_confirmation: admin_password,
    admin: true
  )
end
