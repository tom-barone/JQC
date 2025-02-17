# frozen_string_literal: true

json.extract! application, :id, :reference_number, :converted_to_from, :council_id, :development_application_number,
              :applicant_id, :owner_id, :contact_id, :description, :cancelled, :street_number, :lot_number,
              :street_name, :suburb_id, :electronic_lodgement, :engagement_form, :job_type_administration,
              :quote_accepted_date, :administration_notes, :number_of_storeys, :construction_value, :fee_amount,
              :building_surveyor, :structural_engineer, :risk_rating, :consultancies_review_inspection,
              :consultancies_report_sent, :assessment_commenced, :consent_issued, :variation_issued, :coo_issued,
              :engineer_certificate_received, :certifier, :certification_notes, :invoice_to, :care_of, :invoice_email,
              :attention, :purchase_order_number, :fully_invoiced, :invoice_debtor_notes, :applicant_email,
              :application_type_id, :external_engineer_date, :created_at, :updated_at

json.url application_url(application, format: :json)
