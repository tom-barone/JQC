# frozen_string_literal: true

module ApplicationTypesHelper
  def create_application_types
    create(:application_type, :pc)
    create(:application_type, :q)
    create(:application_type, :c)
  end
end
