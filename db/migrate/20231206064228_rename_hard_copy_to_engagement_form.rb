class RenameHardCopyToEngagementForm < ActiveRecord::Migration[7.0]
  def change
    rename_column :applications, :hard_copy, :engagement_form
  end
end
