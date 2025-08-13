# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 16, max_length: 32, mix_case: true, special_characters: true)
    email { '' }
    username { Faker::Internet.username }
    password { password }
    password_confirmation { password }
  end
end
