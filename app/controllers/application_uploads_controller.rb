class ApplicationUploadsController < ApplicationController
  before_action :set_application_upload, only: [:show, :edit, :update, :destroy]

  # GET /application_uploads
  # GET /application_uploads.json
  def index
    @application_uploads = ApplicationUpload.all
  end

  # GET /application_uploads/1
  # GET /application_uploads/1.json
  def show
  end

  # GET /application_uploads/new
  def new
    @application_upload = ApplicationUpload.new
  end

  # GET /application_uploads/1/edit
  def edit
  end

  # POST /application_uploads
  # POST /application_uploads.json
  def create
    @application_upload = ApplicationUpload.new(application_upload_params)

    respond_to do |format|
      if @application_upload.save
        format.html { redirect_to @application_upload, notice: 'Application upload was successfully created.' }
        format.json { render :show, status: :created, location: @application_upload }
      else
        format.html { render :new }
        format.json { render json: @application_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_uploads/1
  # PATCH/PUT /application_uploads/1.json
  def update
    respond_to do |format|
      if @application_upload.update(application_upload_params)
        format.html { redirect_to @application_upload, notice: 'Application upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @application_upload }
      else
        format.html { render :edit }
        format.json { render json: @application_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_uploads/1
  # DELETE /application_uploads/1.json
  def destroy
    @application_upload.destroy
    respond_to do |format|
      format.html { redirect_to application_uploads_url, notice: 'Application upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_upload
      @application_upload = ApplicationUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_upload_params
      params.require(:application_upload).permit(:uploaded_date, :uploaded_text, :application_id)
    end
end
