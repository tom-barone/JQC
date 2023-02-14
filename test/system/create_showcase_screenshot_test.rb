# frozen_string_literal: true

require 'application_system_test_case'
require 'faker'

# This test is just used to create nice looking screenshots
# without having to show real client data. It is normally skipped.
class CreateShowcaseScreenshotTest < ApplicationSystemTestCase
  test 'create showcase screenshot' do
    skip

    # Create some good looking data for the homepage screenshot
    number_of_applications_to_create = 50
    applications = []
    suburbs = []
    clients = []
    councils = []
    type = ApplicationType.where(application_type: 'PC').take
    1.upto(number_of_applications_to_create) do |n|
      print "\rGenerating random data... #{(n.to_f / number_of_applications_to_create * 100).floor}%"
      $stdout.flush
      applications.append(
        {
          id: n,
          application_type: type,
          reference_number: "REF#{Faker::Number.number(digits: 4)}",
          street_number: Faker::Number.within(range: 1..500).to_s,
          street_name: Faker::Address.street_name,
          suburb_id: Faker::Number.within(range: 1..number_of_applications_to_create),
          description: Faker::Lorem.sentence(word_count: 4, random_words_to_add: 10),
          applicant_id: Faker::Number.within(range: 1..number_of_applications_to_create),
          owner_id: Faker::Number.within(range: 1..number_of_applications_to_create),
          contact_id: Faker::Number.within(range: 1..number_of_applications_to_create),
          council_id: Faker::Number.within(range: 1..number_of_applications_to_create),
          development_application_number: Faker::Number.number(digits: 10).to_s,
          created_at: Faker::Date.between(from: '2022-09-23', to: '2022-12-20')
        }
      )
      suburbs.append(
        {
          id: n,
          display_name: "#{Faker::Address.city.upcase},
            #{Faker::Address.state_abbr} #{Faker::Number.number(digits: 4)}",
          suburb: Faker::Address.city.upcase,
          state: Faker::Address.state_abbr,
          postcode: Faker::Number.number(digits: 4).to_s
        }
      )
      name = [Faker::Name.name, Faker::Company.name]
      clients.append(
        {
          id: n,
          client_name: name.sample # Randomly choose between a company and person name
        }
      )
      councils.append(
        {
          id: n,
          name: "Council of #{Faker::Address.community}"
        }
      )
    end
    puts ' '
    Suburb.create!(suburbs)
    puts 'Suburbs created'
    Client.create!(clients)
    puts 'Clients created'
    Council.create!(councils)
    puts 'Councils created'
    Application.create!(applications)
    puts 'Applications created'

    sign_in_test_user

    page.save_screenshot('tmp/screenshots/homepage_showcase.png')
  end
end
