# frozen_string_literal: true

module Reportable
  extend ActiveSupport::Concern

  included do
    def self.last_rfi_sent_over_3_months_ago_and_no_final_consent_issued(this_month)
      three_months_ago = (this_month << 3).to_s
      with_latest_rfis.includes(:invoices).eager_load_associations.where(
        request_for_informations: { request_for_information_date: ...three_months_ago }
      ).where(consent_issued: nil)
    end

    def self.no_rfi_sent_but_assessment_assigned_over_3_months_ago(this_month)
      three_months_ago = (this_month << 3).to_s
      with_latest_rfis.includes(:invoices).eager_load_associations.where(
        request_for_informations: { request_for_information_date: nil }
      ).where(assessment_commenced: ...three_months_ago)
                      .where(consent_issued: nil)
    end
  end
end
