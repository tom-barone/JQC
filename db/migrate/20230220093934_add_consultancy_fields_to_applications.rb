# frozen_string_literal: true

class AddConsultancyFieldsToApplications < ActiveRecord::Migration[7.0]
  def change
    change_table :applications, bulk: true do |a|
      a.date :consultancies_report_sent, after: :risk_rating
      a.date :consultancies_review_inspection, after: :risk_rating
    end
  end
end
