# frozen_string_literal: true

require 'application_system_test_case'

class ExportToCsvTest < ApplicationSystemTestCase
  def setup_applications_with_data
    q1 = applications(:application_Q1)

    # Fields that should be included in the export
    q1.update!(consultancies_review_inspection: Date.new(2021, 4, 28))
    q1.update!(consultancies_report_sent: Date.new(2021, 4, 29))

    # Add invoices
    assert_on_homepage
    edit_application 'Q8001' # 2 for Q8001 (will be ordered by number ASC)
    application_add_invoice('', '', '', '', '', '', '', 'KD123', false)
    application_add_invoice('', '', '', '', '', '', '', 'KD543', false)
    save_application
    assert_on_homepage
    edit_application 'Q8002' # 1 for Q8002
    application_add_invoice('', '', '', '', '', '', '', 'KD789', false)
    save_application
    assert_on_homepage
  end

  test 'exporting to spreadsheet' do
    sign_in_test_user

    # Filter the page for all Q's
    self.homepage_search_type = 'Q'
    homepage_search
    assert_in_homepage_table 'Q8001'

    setup_applications_with_data

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
    assert_equal(export[1]['consultancies_review_inspection'], '2021-04-28')
    assert_equal(export[1]['consultancies_report_sent'], '2021-04-29')
    assert_equal(export[1]['invoice_numbers'], 'KD123,KD543')
    assert_equal(export[0]['invoice_numbers'], 'KD789')

    # Check that the correct values are excluded
    assert_not(export[0].key?('care_of'))
    assert_not(export[0].key?('attention'))
    assert_not(export[0].key?('purchase_order_number'))
    assert_not(export[0].key?('invoice_debtor_notes'))
  end
end
