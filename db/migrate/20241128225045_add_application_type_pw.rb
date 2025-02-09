# frozen_string_literal: true

class AddApplicationTypePw < ActiveRecord::Migration[7.0]
  def up
    ApplicationType.create!(application_type: 'PW', last_used: 0)
  end

  def down
    ApplicationType.find_by(application_type: 'PW').destroy!
  end
end
