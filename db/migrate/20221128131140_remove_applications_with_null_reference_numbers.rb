# frozen_string_literal: true

class RemoveApplicationsWithNullReferenceNumbers < ActiveRecord::Migration[7.0]
  def up
    Application.where(reference_number: nil).destroy_all
  end
end
