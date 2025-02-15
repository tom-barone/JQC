# frozen_string_literal: true

class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: %i[show edit update destroy]
  include Pagy::Backend

  # GET /applications or /applications.json
  def index
    @number_results_per_page = 1000
    @applications_not_paged = Application.eager_load(:suburb, :council, :applicant, :application_type)
    @total_count = @applications_not_paged.count
    @pagy, @applications =
      pagy(@applications_not_paged, limit: @number_results_per_page)
    @types = ApplicationType.pluck(:application_type)
  end

  # GET /applications/1 or /applications/1.json
  def show; end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit; end

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
        format.html { redirect_to @application, notice: 'Application was successfully updated.' }
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
      format.html do
        redirect_to applications_path, status: :see_other, notice: 'Application was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params.expect(application: %i[reference_number converted_to_from council_id development_application_number
                                  applicant_id owner_id contact_id description cancelled street_number lot_number
                                  street_name suburb_id electronic_lodgement engagement_form job_type_administration
                                  quote_accepted_date administration_notes number_of_storeys construction_value
                                  fee_amount building_surveyor structural_engineer risk_rating
                                  consultancies_review_inspection consultancies_report_sent assessment_commenced
                                  consent_issued variation_issued coo_issued engineer_certificate_received certifier
                                  certification_notes invoice_to care_of invoice_email attention purchase_order_number
                                  fully_invoiced invoice_debtor_notes applicant_email application_type_id
                                  external_engineer_date])
  end
end
