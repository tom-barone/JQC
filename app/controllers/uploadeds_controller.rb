class UploadedsController < ApplicationController
  before_action :set_uploaded, only: [:show, :edit, :update, :destroy]

  # GET /uploadeds
  # GET /uploadeds.json
  def index
    @uploadeds = Uploaded.all
  end

  # GET /uploadeds/1
  # GET /uploadeds/1.json
  def show
  end

  # GET /uploadeds/new
  def new
    @uploaded = Uploaded.new
  end

  # GET /uploadeds/1/edit
  def edit
  end

  # POST /uploadeds
  # POST /uploadeds.json
  def create
    @uploaded = Uploaded.new(uploaded_params)

    respond_to do |format|
      if @uploaded.save
        format.html { redirect_to @uploaded, notice: 'Uploaded was successfully created.' }
        format.json { render :show, status: :created, location: @uploaded }
      else
        format.html { render :new }
        format.json { render json: @uploaded.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploadeds/1
  # PATCH/PUT /uploadeds/1.json
  def update
    respond_to do |format|
      if @uploaded.update(uploaded_params)
        format.html { redirect_to @uploaded, notice: 'Uploaded was successfully updated.' }
        format.json { render :show, status: :ok, location: @uploaded }
      else
        format.html { render :edit }
        format.json { render json: @uploaded.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploadeds/1
  # DELETE /uploadeds/1.json
  def destroy
    @uploaded.destroy
    respond_to do |format|
      format.html { redirect_to uploadeds_url, notice: 'Uploaded was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uploaded
      @uploaded = Uploaded.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def uploaded_params
      params.require(:uploaded).permit(:UploadedDate, :UploadedText, :ApplicationID_id)
    end
end
