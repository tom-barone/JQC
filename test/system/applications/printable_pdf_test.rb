# AI GENERATED - Tom Barone
# frozen_string_literal: true

require 'application_system_test_case'

class PrintablePdfTest < ApplicationSystemTestCase
  include Parallelize

  # Given a signed in user editing an application
  # When they download the printable PDF
  # Then they receive a PDF document
  test 'generates a PDF document' do
    visit_application

    response = download_printable_pdf

    assert_equal 'application/pdf', response.content_type
  end

  # Given a signed in user editing an application
  # When they download the printable PDF
  # Then the browser rendering the PDF loads the Bootstrap stylesheet from the app
  test 'renders the PDF with the bootstrap stylesheet' do
    visit_application

    requested_paths = paths_requested_while { download_printable_pdf }

    assert_includes requested_paths, ActionController::Base.helpers.asset_path('bootstrap.min.css')
  end

  private

  def visit_application
    application = create(:pc90_application)
    sign_in
    visit edit_application_path(application)
  end

  # Fetches the PDF outside the browser, so the call returns once it is fully generated.
  def download_printable_pdf
    Net::HTTP.get_response(URI(find_link('Printable PDF')[:href]), 'Cookie' => session_cookie_header)
  end

  # Paths of the requests the app server handles while the block runs.
  def paths_requested_while(&)
    paths = []
    subscriber = ->(*, payload) { paths << payload[:request].path }
    ActiveSupport::Notifications.subscribed(subscriber, 'request.action_dispatch', &)
    paths
  end
end
