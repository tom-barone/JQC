# frozen_string_literal: true
class RequestForInformationsController < ApplicationController
  before_action :set_request_for_information, only: [:show, :edit, :update, :destroy]

  # GET /request_for_informations
  # GET /request_for_informations.json
  def index
    @request_for_informations = RequestForInformation.all
  end

  # GET /request_for_informations/1
  # GET /request_for_informations/1.json
  def show
  end

  # GET /request_for_informations/new
  def new
    @request_for_information = RequestForInformation.new
  end

  # GET /request_for_informations/1/edit
  def edit
  end

  # POST /request_for_informations
  # POST /request_for_informations.json
  def create
    @request_for_information = RequestForInformation.new(request_for_information_params)

    respond_to do |format|
      if @request_for_information.save
        format.html { redirect_to @request_for_information, notice: 'RequestForInformation was successfully created.' }
        format.json { render :show, status: :created, location: @request_for_information }
      else
        format.html { render :new }
        format.json { render json: @request_for_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /request_for_informations/1
  # PATCH/PUT /request_for_informations/1.json
  def update
    respond_to do |format|
      if @request_for_information.update(request_for_information_params)
        format.html { redirect_to @request_for_information, notice: 'RequestForInformation was successfully updated.' }
        format.json { render :show, status: :ok, location: @request_for_information }
      else
        format.html { render :edit }
        format.json { render json: @request_for_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /request_for_informations/1
  # DELETE /request_for_informations/1.json
  def destroy
    @request_for_information.destroy
    respond_to do |format|
      format.html { redirect_to request_for_informations_url, notice: 'RequestForInformation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request_for_information
      @request_for_information = RequestForInformation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_for_information_params
      params.require(:request_for_information).permit(:request_for_information_date, :application_id)
    end
end
