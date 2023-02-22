# frozen_string_literal: true

require 'application_system_test_case'

class ExportToCsvTest < ApplicationSystemTestCase
  test 'exporting to spreadsheet' do
    sign_in_test_user

    # Setup applications with export data
    q2 = applications(:application_Q2)
    q1 = applications(:application_Q1)
    q2.update!(consultancies_review_inspection: Date.new(2021, 3, 28))
    q2.update!(consultancies_report_sent: Date.new(2021, 3, 29))
    q1.update!(consultancies_review_inspection: Date.new(2021, 4, 28))
    q1.update!(consultancies_report_sent: Date.new(2021, 4, 29))

    # Filter the page for all Q's
    self.homepage_search_type = 'Q'
    homepage_search
    assert_in_homepage_table 'Q8001'

    # Export to a spreadsheet
    accept_confirm { click_on 'Download as Spreadsheet' }
    sleep(Capybara.default_max_wait_time)

    # Check the downloaded CSV exists
    downloads = Dir["#{DOWNLOAD_PATH}/JQC_Applications_Export_*.csv"]
    assert_equal(downloads.length, 1)

    # Check that only the searched applications are exported
    export = CSV.parse(File.read(downloads[0]), headers: true)
    assert_equal(export[0]['reference_number'], 'Q8002')
    assert_equal(export[1]['reference_number'], 'Q8001')
    assert_equal(export.length, 2)

    # Check that the correct values are exported
    assert_equal(export[0]['consultancies_review_inspection'], '2021-03-28')
    assert_equal(export[0]['consultancies_report_sent'], '2021-03-29')
    assert_equal(export[1]['consultancies_review_inspection'], '2021-04-28')
    assert_equal(export[1]['consultancies_report_sent'], '2021-04-29')
  end
end
