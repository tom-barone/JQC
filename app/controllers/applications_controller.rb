# frozen_string_literal: true

require 'csv'

# rubocop:disable Metrics/ClassLength
class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: %i[show edit update destroy]
  before_action :prepare_association_lists, only: %i[show new edit]
  before_action :only_admin, only: %i[destroy]
  include Pagy::Backend

  # GET /applications
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

  # GET /applications/1.pdf
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show
    @converted_application = @application.converted_application
    respond_to do |format|
      format.html { render :show }
      format.pdf do
        # Use Timeout with Concurrent::Future so we don't tank the main thread
        # It's a hack, but whatever.
        # I actually don't think it even works.
        pdf_result = Timeout.timeout(20) do
          future = Concurrent::Future.new do
            RenderPdfJob.perform_now(
              render_to_string(template: 'applications/show', formats: [:html]),
              "#{request.base_url}/",
              request.protocol
            )
          end
          future.execute
          future.value!
        end
        send_data pdf_result, disposition: :inline, filename: "#{@application[:reference_number]}.pdf"
      rescue Timeout::Error
        flash[:warning] = 'PDF generation is taking longer than expected sorry. Please try again.'
        redirect_to edit_application_path(@application)
      rescue StandardError => e
        ExceptionNotifier.notify_exception(e)
        flash[:error] = 'Failed to generate PDF. Please try again later.'
        redirect_to edit_application_path(@application)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
    @converted_application = @application.converted_application
    if @converted_application.present? &&
       @converted_application[:updated_at] > @application[:updated_at]
      flash.now[:warning] = [
        'The related application ',
        { 'text' => @converted_application[:reference_number],
          'link_to' => edit_application_path(@converted_application) },
        ' has been updated more recently.'
      ]
    end
  end

  # POST /applications
  # rubocop:disable Metrics/MethodLength
  def create
    @application = Application.new(application_params)
    respond_to do |format|
      if @application.save
        format.html do
          redirect_to session[:search_results]
          flash[:success] = [
            'Successfully created ',
            { 'text' => @application[:reference_number], 'link_to' => edit_application_path(@application) }
          ]
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /applications/1
  # rubocop:disable Metrics/MethodLength
  def update
    respond_to do |format|
      format.html do
        if @application.update(application_params)
          flash[:success] = [
            'Successfully updated ',
            { 'text' => @application[:reference_number], 'link_to' => edit_application_path(@application) }
          ]
          redirect_to session[:search_results]
        else
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # DELETE /applications/1
  def destroy
    @application.destroy!

    respond_to do |format|
      format.html do
        flash[:success] = ["Successfully deleted #{@application[:reference_number]}"]
        redirect_to session[:search_results]
      end
    end
  end

  private

  def prepare_association_lists
    # Only allow creating / editing active application types,
    # but if we're editing an existing application, include that type
    @application_types = ApplicationType.active.ordered
    @application_types |= [@application&.application_type].compact

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
    @application = Application.eager_load_associations.find(params.expect(:id))
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
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def application_params
    params.expect(application: [
                    :reference_number, :converted_to_from, :council_name, :development_application_number,
                    :applicant_name, :owner_name, :contact_name, :description, :cancelled, :street_number, :lot_number,
                    :street_name, :suburb_display_name, :staged_consent, :engagement_form, :job_type_administration,
                    :quote_accepted_date, :administration_notes, :number_of_storeys, :construction_value, :fee_amount,
                    :building_surveyor, :structural_engineer, :risk_rating, :consultancies_review_inspection,
                    :consultancies_report_sent, :assessment_commenced, :consent_issued, :variation_issued, :coo_issued,
                    :engineer_certificate_received, :certifier, :certification_notes, :invoice_to, :care_of,
                    :invoice_email, :attention, :purchase_order_number, :fully_invoiced, :invoice_debtor_notes,
                    :applicant_email, :area_m2, :application_type_id, :external_engineer_date, :structural_engineer_fee,
                    :certificate_reference, :construction_industry_trading_board, :kd_to_lodge,
                    { invoices_attributes: [
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
                      ] }
                  ])
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
