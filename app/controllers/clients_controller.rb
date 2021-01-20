class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]
  before_action :get_association_lists, only: %i[new edit update create]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html do
          redirect_to @client, notice: 'Client was successfully created.'
        end
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json do
          render json: @client.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to session[:application_page] }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json do
          render json: @client.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      #format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.html { redirect_to session[:search_results] }

      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  def get_association_lists
    @suburbs = Suburb.pluck(:display_name)
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params
      .require(:client)
      .permit(
        :client_type,
        :client_name,
        :first_name,
        :surname,
        :title,
        :initials,
        :salutation,
        :company_name,
        :street,
        :suburb_id,
        :postal_address,
        :postal_suburb_id,
        :australian_business_number,
        :state,
        :phone,
        :mobile_number,
        :fax,
        :email,
        :notes,
        :bad_payer,
        :suburb_display_name,
        :postal_suburb_display_name
      )
  end
end
