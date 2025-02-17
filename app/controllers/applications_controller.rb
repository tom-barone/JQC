# frozen_string_literal: true

require 'csv'

class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: %i[show edit update destroy]
  include Pagy::Backend

  # GET /applications or /applications.json
  def index
    @params = search_params
    @number_results_per_page = 500
    @all_applications = Application.search(@params)
    @pagy, @applications = pagy(@all_applications, limit: @number_results_per_page)
    @total_count = @pagy.count
    respond_to do |format|
      format.csv { Application.write_csv_response(@all_applications, response) }
      format.html { session[:search_results] = request.url } # Save the search results for later
    end
  end

  # GET /applications/1 or /applications/1.json
  def show; end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
    @converted_application =
      Application.where(reference_number: @application[:converted_to_from])
                 .first
    prepare_association_lists
  end

  # POST /applications or /applications.json
  def create
    @application = Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to @application, notice: 'Application was successfully created.' }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to session[:search_results] }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1 or /applications/1.json
  def destroy
    @application.destroy!

    respond_to do |format|
      format.html { redirect_to session[:search_results] }
      format.json { head :no_content }
    end
  end

  private

  def prepare_association_lists
    # Cache the lists of suburbs, since they'll never change really
    @suburbs = Rails.cache.fetch('association_lists_suburbs', expires_in: 1.day) do
      Suburb.pluck(:display_name)
    end
    # These may change more frequently, there's not much else we can do here
    @clients = Client.pluck(:client_name)
    @councils = Council.pluck(:name)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params.expect(:id))
  end

  def search_params
    params.permit(
      :type,
      :start_date,
      :end_date,
      :search_text,
      :page,  # What page of results
      :format # Whether we're asking for HTML or CSV
    )
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params.expect(application: %i[reference_number converted_to_from council_name development_application_number
                                  applicant_name owner_name contact_name description cancelled street_number lot_number
                                  street_name suburb_display_name electronic_lodgement engagement_form job_type_administration
                                  quote_accepted_date administration_notes number_of_storeys construction_value
                                  fee_amount building_surveyor structural_engineer risk_rating
                                  consultancies_review_inspection consultancies_report_sent assessment_commenced
                                  consent_issued variation_issued coo_issued engineer_certificate_received certifier
                                  certification_notes invoice_to care_of invoice_email attention purchase_order_number
                                  fully_invoiced invoice_debtor_notes applicant_email application_type_id
                                  external_engineer_date])
  end
end
