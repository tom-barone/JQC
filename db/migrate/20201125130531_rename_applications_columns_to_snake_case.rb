# frozen_string_literal: true

class RenameApplicationsColumnsToSnakeCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :applications, :ApplicationID, :id
    rename_column :applications, :ApplicationType, :application_type
    rename_column :applications, :ReferenceNo, :reference_number
    rename_column :applications, :ConvertedToFrom, :converted_to_from
    rename_column :applications, :DateEntered, :date_entered
    rename_column :applications, :CouncilID, :council_id
    rename_column :applications, :DANo, :development_application_number
    rename_column :applications, :ApplicantID, :applicant_id
    rename_column :applications, :ApplicantCouncilID, :applicant_council_id
    rename_column :applications, :OwnerID, :owner_id
    rename_column :applications, :OwnerCouncilID, :owner_council_id
    rename_column :applications, :ClientID, :client_id
    rename_column :applications, :ClientCouncilID, :client_council_id
    rename_column :applications, :Description, :description
    rename_column :applications, :Cancelled, :cancelled
    rename_column :applications, :StreetNo, :street_number
    rename_column :applications, :LotNo, :lot_number
    rename_column :applications, :StreetName, :street_name
    rename_column :applications, :SuburbID, :suburb_id
    rename_column :applications, :Section93A, :section_93A
    rename_column :applications, :ElectronicLodgement, :electronic_lodgement
    rename_column :applications, :HardCopy, :hard_copy
    rename_column :applications, :JobTypeAdministration, :job_type_administration
    rename_column :applications, :QuoteAcceptedDate, :quote_accepted_date
    rename_column :applications, :AdministrationNotes, :administration_notes
    rename_column :applications, :FeeAmount, :fee_amount
    rename_column :applications, :BuildingSurveyor, :building_surveyor
    rename_column :applications, :StructuralEngineer, :structural_engineer
    rename_column :applications, :RiskRating, :risk_rating
    rename_column :applications, :AssesmentCommenced, :assesment_commenced
    rename_column :applications, :RFIIssued, :request_for_information_issued
    rename_column :applications, :ConsentIssued, :consent_issued
    rename_column :applications, :VariationIssued, :variation_issued
    rename_column :applications, :Staged, :staged
    rename_column :applications, :COOIssued, :coo_issued
    rename_column :applications, :JobType, :job_type
    rename_column :applications, :Consent, :consent
    rename_column :applications, :Certifier, :certifier
    rename_column :applications, :CertificationNotes, :certification_notes
    rename_column :applications, :InvoiceTo, :invoice_to
    rename_column :applications, :CareOf, :care_of
    rename_column :applications, :InvoiceToID, :invoice_to_id
    rename_column :applications, :CareOfID, :care_of_id
    rename_column :applications, :InvoiceEmail, :invoice_email
    rename_column :applications, :Attention, :attention
    rename_column :applications, :PurchaseOrderNo, :purchase_order_number
    rename_column :applications, :FullyInvoiced, :fully_invoiced
    rename_column :applications, :InvoiceDebtorNotes, :invoice_debtor_notes
    rename_column :applications, :ApplicantEmail, :applicant_email
    rename_column :applications, :SortPriorityGen, :sort_priority_gen
  end
end
