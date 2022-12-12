# frozen_string_literal: true

class ApplicationAdditionalInformationsController < ApplicationController
  before_action :set_application_additional_information, only: %i[show edit update destroy]

  # GET /application_additional_informations
  # GET /application_additional_informations.json
  def index
    @application_additional_informations = ApplicationAdditionalInformation.all
  end

  # GET /application_additional_informations/1
  # GET /application_additional_informations/1.json
  def show; end

  # GET /application_additional_informations/new
  def new
    @application_additional_information = ApplicationAdditionalInformation.new
  end

  # GET /application_additional_informations/1/edit
  def edit; end

  # POST /application_additional_informations
  # POST /application_additional_informations.json
  def create
    @application_additional_information = ApplicationAdditionalInformation.new(application_additional_information_params)

    respond_to do |format|
      if @application_additional_information.save
        format.html do
          redirect_to @application_additional_information,
                      notice: 'Application additional information was successfully created.'
        end
        format.json { render :show, status: :created, location: @application_additional_information }
      else
        format.html { render :new }
        format.json { render json: @application_additional_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_additional_informations/1
  # PATCH/PUT /application_additional_informations/1.json
  def update
    respond_to do |format|
      if @application_additional_information.update(application_additional_information_params)
        format.html do
          redirect_to @application_additional_information,
                      notice: 'Application additional information was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @application_additional_information }
      else
        format.html { render :edit }
        format.json { render json: @application_additional_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_additional_informations/1
  # DELETE /application_additional_informations/1.json
  def destroy
    @application_additional_information.destroy
    respond_to do |format|
      format.html do
        redirect_to application_additional_informations_url,
                    notice: 'Application additional information was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application_additional_information
    @application_additional_information = ApplicationAdditionalInformation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def application_additional_information_params
    params.require(:application_additional_information).permit(:info_date, :info_text, :application_id)
  end
end
