# frozen_string_literal: true

module CsvReportable
  extend ActiveSupport::Concern

  included do
    def self.last_rfi_sent_over_3_months_ago_and_no_final_consent_issued(this_month)
      three_months_ago = (this_month << 3).to_s
      to_csv(with_latest_rfis.includes(:invoices).eager_load_associations.where(
        request_for_informations: { request_for_information_date: ...three_months_ago }
      ).where(consent_issued: nil))
    end

    def self.to_csv(applications)
      CSV.generate(headers: true) do |csv|
        csv << csv_columns.map(&:first)
        applications.find_in_batches(batch_size: 1000) do |batch|
          batch.each do |application|
            csv << csv_columns.map { |_, getter| getter.call(application) }
          end
        end
      end
    end
  end
end
