# frozen_string_literal: true

class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  # TODO: Maybe needed for csv exports
  # include ActionController::Live

  before_action :set_application, only: %i[show edit update destroy]
  before_action :prepare_association_lists, only: %i[new edit update create]

  # GET /applications
  # GET /applications.json
  def index
    params.permit(
      :type,
      :start_date,
      :end_date,
      :search_text,
      :commit,
      :format,
      :page
    )
    flash.clear

    @number_results_per_page = 1000

    @applications_not_paged = ApplicationSearchResult.filter_all(params)
    @total_count = @applications_not_paged.count
    @pagy, @applications =
      pagy(@applications_not_paged, items: @number_results_per_page)

    @types = ApplicationType.pluck(:application_type)

    respond_to do |format|
      format.html { session[:search_results] = request.url }
      format.csv { send_csv_export }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show; end

  # GET /applications/new
  def new
    @application = Application.new
    session[:application_page] = request.url
  end

  # GET /applications/1/edit
  def edit
    @converted_application =
      Application.where(reference_number: @application[:converted_to_from])
                 .first

    if @converted_application.present? &&
       @converted_application[:updated_at] > @application[:updated_at]
      flash.now[:warning] =
        "Warning: The related application #{@application[:converted_to_from]} has been updated more recently. "
    end
    session[:application_page] = request.url
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to session[:search_results] }
        format.json { render :new, status: :created, location: @application }
      else
        format.html { render :new }
        format.json do
          render json: @application.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to session[:search_results] }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit, location: @application }
        format.json do
          render json: @application.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application.destroy
    respond_to do |format|
      format.html do
        redirect_to session[:search_results]
      end
      format.json { head :no_content }
    end
  end

  private

  def send_csv_export
    file_name = "JQC_Applications_Export_#{Time.zone.now.strftime('%d/%m/%Y')}.csv"
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-disposition'] =
      "attachment; filename=\"#{file_name}\""
    response.headers['X-Accel-Buffering'] = 'no'
    response.headers['Cache-Control'] ||= 'no-cache'
    response.headers['Last-Modified'] = Time.current.httpdate
    response.headers.delete('Content-Length')
    response.status = 200

    response.stream.write(ApplicationsCsvResult.csv_header.to_s)

    ApplicationsCsvResult.find_in_batches(params) do |a|
      response.stream.write(
        CSV.generate_line(
          ApplicationsCsvResult::HEADERS.map { |header| a.send(header) }
        )
      )
    end
  ensure
    response.stream.close
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def prepare_association_lists
    @suburbs = Suburb.pluck(:display_name)
    @clients = Client.pluck(:client_name)
    @councils = Council.pluck(:name)
    @types = ApplicationType.order(:application_type)
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params
      .require(:application)
      .permit(
        :application_type_id,
        :reference_number,
        :converted_to_from,
        :created_at,
        :council_name,
        :development_application_number,
        :applicant_name,
        :owner_name,
        :contact_name,
        :description,
        :cancelled,
        :street_number,
        :lot_number,
        :street_name,
        :suburb_display_name,
        :electronic_lodgement,
        :engagement_form,
        :job_type_administration,
        :quote_accepted_date,
        :administration_notes,
        :number_of_storeys,
        :construction_value,
        :fee_amount,
        :building_surveyor,
        :structural_engineer,
        :external_engineer_date,
        :risk_rating,
        :consultancies_review_inspection,
        :consultancies_report_sent,
        :assessment_commenced,
        :request_for_information_issued,
        :consent_issued,
        :variation_issued,
        :coo_issued,
        :certifier,
        :engineer_certificate_received,
        :certification_notes,
        :invoice_to,
        :care_of,
        :invoice_email,
        :attention,
        :purchase_order_number,
        :fully_invoiced,
        :invoice_debtor_notes,
        :applicant_email,
        invoices_attributes: [
          Invoice.attribute_names.map(&:to_sym).push(:_destroy)
        ],
        application_additional_informations_attributes: [
          ApplicationAdditionalInformation
            .attribute_names
            .map(&:to_sym)
            .push(:_destroy)
        ],
        application_uploads_attributes: [
          ApplicationUpload.attribute_names.map(&:to_sym).push(:_destroy)
        ],
        stages_attributes: [
          Stage.attribute_names.map(&:to_sym).push(:_destroy)
        ],
        request_for_informations_attributes: [
          RequestForInformation.attribute_names.map(&:to_sym).push(:_destroy)
        ]
      )
  end
end
