# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  # GET /building_surveyor_search
  def building_surveyor_search
    @params = building_surveyor_search_params
    @number_results_per_page = 500
    @all_applications = Application.building_surveyor_search(@params)
    @pagy, @applications = pagy(@all_applications, limit: @number_results_per_page)
    @total_count = @pagy.count
    session[:search_results] = request.url # Save the search results for later
  end

  private

  # rubocop:disable Metrics/MethodLength
  def building_surveyor_search_params
    params.permit(
      :type,
      :start_date,
      :end_date,
      :search_text,
      :building_surveyor,
      :has_rfis_issued,
      :has_additional_information,
      :has_received_engineer_certificate,
      :has_invoices_outstanding,
      :page,  # What page of results
      :format # Whether we're asking for HTML or CSV
    )
  end
  # rubocop:enable Metrics/MethodLength
end
