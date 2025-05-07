# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength, Metrics/BlockLength, Metrics/MethodLength
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

    def self.last_3_months_quotes(this_month)
      three_months_ago = (this_month << 3).to_s
      end_of_last_month = this_month - 1
      ActiveRecord::Base.connection.exec_query(
        "select
              created_at,
              quote_number,
              building_surveyor,
              fee_amount as quote_cost,
              quote_accepted_date,
              case
                  when (converted_to_from ~ '^PC.*') then converted_to_from
              else null end as PC_converted,
              case
                  when (converted_to_from ~ '^C.*') then converted_to_from
              else null end as C_converted
          from (
              select
                  created_at,
                  case
                      when (reference_number ~ '^Q.*') then reference_number
                  else converted_to_from end as quote_number,
                  case
                      when (reference_number ~ '^Q.*') then converted_to_from
                  else reference_number end as converted_to_from,
                  quote_accepted_date,
                  fee_amount,
                  building_surveyor
              from applications
              where
              (reference_number like 'Q%' or converted_to_from like 'Q%') and
              created_at >= '#{three_months_ago}' and created_at <= '#{end_of_last_month}' and
              cancelled is not true
              group by quote_number, created_at, converted_to_from, quote_accepted_date,
                fee_amount, building_surveyor, reference_number
          ) as a order by created_at asc"
      )
    end

    def self.overdue_pcs(this_month)
      three_months_ago = (this_month << 3).to_s
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
               and a.assessment_commenced <= '#{three_months_ago}'
               or -- 3 months have passed since the RFI date
         rfi.latest_request_for_information_date is not null
               and rfi.latest_request_for_information_date <= '#{three_months_ago}')
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
        order by date_entered asc"
      )
    end

    def self.last_month_pcs(this_month)
      last_month_end = this_month - 1 # minus one day to get last day of month
      last_month_start = last_month_end.beginning_of_month
      ActiveRecord::Base.connection.exec_query(
        "select
          a.reference_number,
          a.consent_issued,
          a.created_at as date_entered,
          a.risk_rating,
          c.client_name,
          a.building_surveyor,
          string_agg(se.structural_engineer, ', ') as structural_engineers,
          a.job_type_administration as job_type,
          a.assessment_commenced as assessment_started
      from applications a
      left join clients c on c.id = a.applicant_id
      left join structural_engineers se on se.application_id = a.id
      where a.reference_number like 'PC%' and
      a.consent_issued >= '#{last_month_start}' and a.consent_issued <= '#{last_month_end}'
      group by
        a.reference_number,
        a.consent_issued,
        a.created_at,
        a.risk_rating,
        c.client_name,
        a.building_surveyor,
        a.job_type_administration,
        a.assessment_commenced
      order by consent_issued asc"
      )
    end

    def self.pcs_with_invoices_sent_and_consent_not_issued
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
          i.invoice_date >= '2024-01-01' and
          a.cancelled is not true
      order by invoice_date"
      )
    end
  end
end
# rubocop:enable Metrics/ModuleLength, Metrics/BlockLength, Metrics/MethodLength
