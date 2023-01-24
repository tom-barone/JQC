# frozen_string_literal: true

require 'application_system_test_case'

class ExportToCsvTest < ApplicationSystemTestCase
  test 'exporting to spreadsheet' do
    sign_in_test_user

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
  end
end
