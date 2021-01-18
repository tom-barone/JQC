class ApplicationTypesController < ApplicationController
  before_action :set_application_type, only: %i[show edit update destroy]

  def update_all
    params['application_type_attributes'].keys.each do |id|
      @application_type = ApplicationType.find(id.to_i)
      @application_type.update(
        last_used: params['application_type_attributes'][id]['last_used']
      )
    end
    redirect_to session[:search_results]
  end

  # GET /application_types
  # GET /application_types.json
  def index
    @application_types = ApplicationType.all
  end

  # GET /application_types/1
  # GET /application_types/1.json
  def show; end

  # GET /application_types/new
  def new
    @application_type = ApplicationType.new
  end

  # GET /application_types/1/edit
  def edit; end

  # POST /application_types
  # POST /application_types.json
  def create
    @application_type = ApplicationType.new(application_type_params)

    respond_to do |format|
      if @application_type.save
        format.html do
          redirect_to @application_type,
                      notice: 'Application type was successfully created.'
        end
        format.json do
          render :show, status: :created, location: @application_type
        end
      else
        format.html { render :new }
        format.json do
          render json: @application_type.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /application_types/1
  # PATCH/PUT /application_types/1.json
  def update
    respond_to do |format|
      if @application_type.update(application_type_params)
        format.html do
          redirect_to @application_type,
                      notice: 'Application type was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @application_type }
      else
        format.html { render :edit }
        format.json do
          render json: @application_type.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /application_types/1
  # DELETE /application_types/1.json
  def destroy
    @application_type.destroy
    respond_to do |format|
      format.html do
        redirect_to application_types_url,
                    notice: 'Application type was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application_type
    @application_type = ApplicationType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def application_type_params
    params.require(:application_type).permit(:application_type, :last_used)
  end
end
