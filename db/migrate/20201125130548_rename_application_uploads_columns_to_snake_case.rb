# frozen_string_literal: true

class RenameApplicationUploadsColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :application_uploads, :UploadedId, :id
    rename_column :application_uploads, :UploadedDate, :uploaded_date
    rename_column :application_uploads, :UploadedText, :uploaded_text
    rename_column :application_uploads, :ApplicationID, :application_id
  end
end
