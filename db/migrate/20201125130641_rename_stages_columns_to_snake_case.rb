# frozen_string_literal: true

class RenameStagesColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :stages, :StageId, :stage_id
    rename_column :stages, :StageDate, :stage_date
    rename_column :stages, :StageText, :stage_text
    rename_column :stages, :ApplicationID, :application_id
  end
end
