class CouncilsController < ApplicationController
  before_action :set_council, only: %i[show edit update destroy]
  before_action :get_association_lists, only: %i[new edit update create]

  # GET /councils
  # GET /councils.json
  def index
    @councils = Council.all
  end

  # GET /councils/1
  # GET /councils/1.json
  def show; end

  # GET /councils/new
  def new
    @council = Council.new
  end

  # GET /councils/1/edit
  def edit; end

  # POST /councils
  # POST /councils.json
  def create
    @council = Council.new(council_params)

    respond_to do |format|
      if @council.save
        format.html do
          redirect_to @council, notice: 'Council was successfully created.'
        end
        format.json { render :show, status: :created, location: @council }
      else
        format.html { render :new }
        format.json do
          render json: @council.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /councils/1
  # PATCH/PUT /councils/1.json
  def update
    respond_to do |format|
      if @council.update(council_params)
        format.html { redirect_to session[:application_page] }
        format.json { render :show, status: :ok, location: @council }
      else
        format.html { render :edit }
        format.json do
          render json: @council.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /councils/1
  # DELETE /councils/1.json
  def destroy
    @council.destroy
    respond_to do |format|
      format.html do
        redirect_to councils_url, notice: 'Council was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_council
    @council = Council.find(params[:id])
  end

  def get_association_lists
    @suburbs = Suburb.pluck(:display_name)
  end

  # Only allow a list of trusted parameters through.
  def council_params
    params
      .require(:council)
      .permit(
        :name,
        :city,
        :street,
        :state,
        :suburb_id,
        :postal_address,
        :postal_suburb_id,
        :phone,
        :fax,
        :email,
        :notes,
        :suburb_display_name,
        :postal_suburb_display_name
      )
  end
end
