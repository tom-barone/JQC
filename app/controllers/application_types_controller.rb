# frozen_string_literal: true

class ApplicationTypesController < ApplicationController
  before_action :authenticate_user!

  # rubocop:disable Metrics/AbcSize
  def update_all
    application_type_params.each_key do |id|
      @application_type = ApplicationType.find(id.to_i)
      @application_type.update(
        last_used: application_type_params[id]['last_used'],
        display_priority: application_type_params[id]['display_priority'],
        active: application_type_params[id]['active']
      )
    end
    redirect_to session[:search_results] || '/'
  end
  # rubocop:enable Metrics/AbcSize

  def edit
    @application_types = ApplicationType.ordered
  end

  private

  # Only allow a list of trusted parameters through.
  def application_type_params
    params.expect(application_type_attributes: [
                    ApplicationType.attribute_names
                      .map(&:to_sym)
                      .push(:_destroy)
                  ])
  end
end
