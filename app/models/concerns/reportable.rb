# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength, Metrics/MethodLength
module Reportable
  extend ActiveSupport::Concern

  included do
    def self.applications_with_no_final_consent_issued(latest_rfi_sent_before_date)
      with_latest_rfis.includes(:invoices).eager_load_associations.where(
        request_for_informations: { request_for_information_date: ...latest_rfi_sent_before_date }
      ).where(consent_issued: nil)
    end

    def self.applications_with_no_rfi_sent(assessment_assigned_before_date)
      with_latest_rfis.includes(:invoices).eager_load_associations.where(
        request_for_informations: { request_for_information_date: nil }
      ).where(assessment_commenced: ...assessment_assigned_before_date)
                      .where(consent_issued: nil)
    end

    def self.overdue_pcs(assessment_assigned_before_date, latest_rfi_sent_before_date)
      ActiveRecord::Base.connection.exec_query(
        "select a.reference_number,
               a.assessment_commenced as assessment_started,
               rfi.latest_request_for_information_date,
               a.consent_issued,
               a.created_at as date_entered,
               a.risk_rating,
               c.client_name,
               a.building_surveyor,
               string_agg(se.structural_engineer, ', ') as structural_engineers,
               a.job_type_administration as job_type,
               a.description
        from applications a
        left join clients c on c.id = a.applicant_id
        left join structural_engineers se on se.application_id = a.id
        left join
          (select application_id,
                  MAX(request_for_information_date) as latest_request_for_information_date
           from request_for_informations
           group by application_id) as rfi on a.id = rfi.application_id
        where a.reference_number like 'PC%'
          and a.consent_issued is null
          and a.assessment_commenced is not null
          and (-- 3 months have passed since assesment and no RFI date
         rfi.latest_request_for_information_date is null
               and a.assessment_commenced <= $1
               or -- 3 months have passed since the RFI date
         rfi.latest_request_for_information_date is not null
               and rfi.latest_request_for_information_date <= $2)
          and cancelled is not true
		 group by
		   a.reference_number,
		   a.assessment_commenced,
		   rfi.latest_request_for_information_date,
		   a.consent_issued,
		   a.created_at,
		   a.risk_rating,
		   c.client_name,
		   a.building_surveyor,
		   a.job_type_administration,
		   a.description
        order by date_entered asc",
        nil,
        [assessment_assigned_before_date, latest_rfi_sent_before_date]
      )
    end

    def self.pcs_with_invoices_sent_and_consent_not_issued(invoice_date_after)
      ActiveRecord::Base.connection.exec_query(
        "select
          i.invoice_date,
          a.reference_number,
          c.client_name as applicant,
          a.invoice_email,
          c.email as applicant_email,
          concat(a.lot_number, ' ', a.street_number, ' ', a.street_name, ' ', s.display_name) as street_address,
          a.building_surveyor,
          i.invoice_number,
          i.fee,
          case when i.paid is true then 'yes' else 'no' end as paid
      from invoices as i
      inner join applications as a on a.id = i.application_id
      inner join suburbs as s on a.suburb_id = s.id
      inner join clients as c on a.applicant_id = c.id
      inner join application_types as t on a.application_type_id = t.id
      where
          i.invoice_date is not null and
          i.fee is not null and
          t.application_type = 'PC' and
          a.consent_issued is null and
          i.invoice_date >= $1 and
          a.cancelled is not true
      order by invoice_date",
        nil,
        [invoice_date_after]
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/MethodLength
