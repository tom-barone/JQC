class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
  end

  def new
    @application = Application.new
  end

  def edit
    @application = Application.find(params[:id])
  end

  def create
    @application = Application.new(application_params)
   
    if @application.save
      redirect_to @application
    else
      render 'new'
    end
  end

  def update
    @application = Application.find(params[:id])
   
    if @application.update(application_params)
      redirect_to @application
    else
      render 'edit'
    end
  end
  
  def destroy
    @application = Application.find(params[:id])
    @application.destroy
   
    redirect_to applications_path
  end

  private
    def application_params
      params.require(:application).permit(:reference_number)
    end
end
