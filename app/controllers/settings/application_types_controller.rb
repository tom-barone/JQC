# frozen_string_literal: true

module Settings
  class ApplicationTypesController < ApplicationController
    before_action :authenticate_user!

    def edit
      @application_types = ApplicationType.ordered
    end

    def update
      application_type_params.each { |id, attrs| upsert_application_type(id, attrs) }
      redirect_to session[:search_results] || '/'
    end

    private

    def upsert_application_type(id, attrs)
      existing = ApplicationType.find_by(id: id)
      if existing
        existing.update(attrs.slice('last_used', 'display_priority', 'active'))
      elsif attrs['application_type'].present?
        ApplicationType.create(attrs.slice('application_type', 'last_used', 'display_priority', 'active'))
      end
    end

    def application_type_params
      params.expect(application_type_attributes: [
                      ApplicationType.attribute_names
                        .map(&:to_sym)
                        .push(:_destroy)
                    ])
    end
  end
end
