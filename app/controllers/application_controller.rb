class ApplicationController < ActionController::Base
  def new
  end

  def create
    render plain: params[:application].inspect
  end
end
