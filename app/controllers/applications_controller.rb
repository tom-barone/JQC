class ApplicationsController < ApplicationController
  include Pagy::Backend

  before_action :set_application, only: %i[show edit update destroy]

  # GET /applications
  # GET /applications.json
  def index
    params.permit(:type, :start_date, :end_date, :search_text, :format, :page)

    @number_results_per_page = 1000
    
    @applications_not_paged = ApplicationSearchResult.filter_all(params)
    @total_count = @applications_not_paged.count
    @pagy, @applications = pagy(@applications_not_paged, items: @number_results_per_page)

    
    @types = ApplicationType.pluck(:application_type)

    respond_to do |format|
      format.html
      format.csv { send_data ApplicationsCsvResult.filter_all(params).to_csv }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show; end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
    @suburbs = Suburb.where(state: 'SA').pluck(:display_name)
    @clients = Client.pluck(:client_name)
    @councils = Council.pluck(:name)
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html do
          redirect_to @application,
                      notice: 'Application was successfully created.'
        end
        format.json { render :show, status: :created, location: @application }
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
    @suburbs = Suburb.where(state: 'SA').pluck(:display_name)
    @clients = Client.pluck(:client_name)
    @councils = Council.pluck(:name)

    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to applications_url }
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
        redirect_to applications_url,
                    notice: 'Application was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params
      .require(:application)
      .permit(
        :application_type_id,
        :reference_number,
        :converted_to_from,
        :council_id,
        :development_application_number,
        :applicant_name,
        :applicant_council_id,
        :owner_name,
        :owner_council_id,
        :client_name,
        :client_council_id,
        :description,
        :cancelled,
        :street_number,
        :lot_number,
        :street_name,
        :suburb_display_name,
        :section_93A,
        :electronic_lodgement,
        :hard_copy,
        :job_type_administration,
        :quote_accepted_date,
        :administration_notes,
        :fee_amount,
        :building_surveyor,
        :structural_engineer,
        :risk_rating,
        :assesment_commenced,
        :request_for_information_issued,
        :consent_issued,
        :variation_issued,
        :coo_issued,
        :job_type,
        :consent,
        :certifier,
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
        ]
      )
  end
end
