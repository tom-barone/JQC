# frozen_string_literal: true

class RenameAssessmentCommencedColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :applications, :assesment_commenced, :assessment_commenced
  end
end
