class CreateApplicationsCsvResults < ActiveRecord::Migration[6.0]
  def change
    create_view :applications_csv_results
  end
end
