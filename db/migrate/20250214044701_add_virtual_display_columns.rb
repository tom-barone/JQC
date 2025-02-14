# frozen_string_literal: true

class AddVirtualDisplayColumns < ActiveRecord::Migration[8.0]
  def change
    add_column :suburbs, :display_name,
               :virtual, type: :string, stored: true,
                         as: "suburb || ', ' || state || ' ' || postcode"

    add_column :applications, :location,
               :virtual, type: :string, stored: true,
                         as: "COALESCE(lot_number || ' ', '') || COALESCE(street_number || ' ', '') || street_name"
  end
end
