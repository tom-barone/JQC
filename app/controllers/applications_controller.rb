class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  # GET /applications
  # GET /applications.json
  def index
    @applications = Application.order(updated_at: :desc).take(10)
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
  end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to @application, notice: 'Application was successfully created.' }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to @application, notice: 'Application was successfully updated.' }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url, notice: 'Application was successfully destroyed.' }
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
      params.require(:application).permit(:application_type, :reference_number, :converted_to_from, :council_id, :development_application_number, :applicant_id, :applicant_council_id, :owner_id, :owner_council_id, :client_id, :client_council_id, :description, :cancelled, :street_number, :lot_number, :street_name, :suburb_id, :section_93A, :electronic_lodgement, :hard_copy, :job_type_administration, :quote_accepted_date, :administration_notes, :fee_amount, :building_surveyor, :structural_engineer, :risk_rating, :assesment_commenced, :request_for_information_issued, :consent_issued, :variation_issued, :staged, :coo_issued, :job_type, :consent, :certifier, :certification_notes, :invoice_to, :care_of, :invoice_to_id, :care_of_id, :invoice_email, :attention, :purchase_order_number, :fully_invoiced, :invoice_debtor_notes, :applicant_email, :sort_priority_gen)
    end
end
