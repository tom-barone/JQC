# frozen_string_literal: true

class ApplicationTypesController < ApplicationController
  before_action :authenticate_user!
  def update_all
    application_type_params.each_key do |id|
      @application_type = ApplicationType.find(id.to_i)
      @application_type.update(
        last_used: application_type_params[id]['last_used']
      )
    end
    redirect_to session[:search_results]
  end

  def index
    @application_types = ApplicationType.order(:application_type)
  end

  private

  # Only allow a list of trusted parameters through.
  def application_type_params
    params.require(:application_type_attributes).permit!
  end
end
