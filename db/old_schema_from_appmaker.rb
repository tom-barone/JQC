# frozen_string_literal: true
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "AdditionalInfo", primary_key: "InfoId", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "InfoDate"
    t.text "InfoText"
    t.integer "ApplicationID"
    t.index ["ApplicationID"], name: "fk_application"
  end

  create_table "ApplicationTypes", primary_key: "ApplicationType", id: :string, limit: 10, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "LastUsed", null: false
  end

  create_table "Applications", primary_key: "ApplicationID", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ApplicationType", limit: 5
    t.text "ReferenceNo"
    t.text "ConvertedToFrom"
    t.date "DateEntered"
    t.integer "CouncilID"
    t.text "DANo"
    t.integer "ApplicantID"
    t.integer "ApplicantCouncilID"
    t.integer "OwnerID"
    t.integer "OwnerCouncilID"
    t.integer "ClientID"
    t.integer "ClientCouncilID"
    t.text "Description"
    t.boolean "Cancelled", default: false
    t.text "StreetNo"
    t.text "LotNo"
    t.text "StreetName"
    t.integer "SuburbID"
    t.date "Section93A"
    t.boolean "ElectronicLodgement", default: false
    t.boolean "HardCopy", default: false
    t.text "JobTypeAdministration"
    t.date "QuoteAcceptedDate"
    t.text "AdministrationNotes"
    t.decimal "FeeAmount", precision: 13, scale: 2
    t.text "BuildingSurveyor"
    t.text "StructuralEngineer"
    t.text "RiskRating"
    t.date "AssesmentCommenced"
    t.date "RFIIssued"
    t.date "ConsentIssued"
    t.date "VariationIssued"
    t.date "Staged"
    t.date "COOIssued"
    t.text "JobType"
    t.text "Consent"
    t.text "Certifier"
    t.text "CertificationNotes"
    t.text "InvoiceTo"
    t.text "CareOf"
    t.integer "InvoiceToID"
    t.integer "CareOfID"
    t.text "InvoiceEmail"
    t.text "Attention"
    t.text "PurchaseOrderNo"
    t.boolean "FullyInvoiced", default: false
    t.text "InvoiceDebtorNotes"
    t.text "ApplicantEmail"
    t.integer "SortPriorityGen", limit: 1
    t.index ["ApplicantCouncilID"], name: "fk_applicant_council"
    t.index ["ApplicantID"], name: "fk_applicant"
    t.index ["ApplicationType"], name: "fk_type"
    t.index ["CareOfID"], name: "fk_careof"
    t.index ["ClientCouncilID"], name: "fk_client_council"
    t.index ["ClientID"], name: "fk_client"
    t.index ["CouncilID"], name: "fk_council"
    t.index ["DateEntered"], name: "date_entered_idx"
    t.index ["InvoiceToID"], name: "fk_invoiceto"
    t.index ["OwnerCouncilID"], name: "fk_owner_council"
    t.index ["OwnerID"], name: "fk_owner"
    t.index ["SuburbID"], name: "fk_suburb"
  end

  create_table "Clients", primary_key: "ClientID", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "ClientType"
    t.text "ClientName"
    t.text "FirstName"
    t.text "Surname"
    t.text "Title"
    t.text "Initials"
    t.text "Salutation"
    t.text "CompanyName"
    t.text "Street"
    t.integer "SuburbID"
    t.text "PostalAddress"
    t.integer "PostalSuburbID"
    t.text "ABN"
    t.string "State", limit: 10
    t.text "Phone"
    t.text "MobileNo"
    t.text "Fax"
    t.text "Email"
    t.text "Notes"
    t.boolean "BadPayer", default: false
    t.index ["PostalSuburbID"], name: "fk_postalsuburb"
    t.index ["SuburbID"], name: "fk_suburb"
  end

  create_table "Councils", primary_key: "CouncilID", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "Name"
    t.text "City"
    t.text "Street"
    t.string "State", limit: 10
    t.integer "SuburbID"
    t.text "PostalAddress"
    t.integer "PostalSuburbID"
    t.text "Phone"
    t.text "Fax"
    t.text "Email"
    t.text "Notes"
    t.index ["PostalSuburbID"], name: "fk_postalsuburb"
    t.index ["SuburbID"], name: "fk_suburb"
  end

  create_table "Invoices", primary_key: "InvoiceId", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "InvoiceNo"
    t.text "Stage"
    t.decimal "Fee", precision: 13, scale: 2
    t.decimal "GST", precision: 13, scale: 2
    t.decimal "DAC", precision: 13, scale: 2
    t.decimal "Lodgement", precision: 13, scale: 2
    t.decimal "InsLevy", precision: 13, scale: 2
    t.decimal "PercentInvoiced", precision: 13, scale: 2
    t.date "InvoiceDate"
    t.boolean "Paid"
    t.integer "ApplicationID"
    t.index ["ApplicationID"], name: "fk_application"
  end

  create_table "Stages", primary_key: "StageId", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "StageDate"
    t.text "StageText"
    t.integer "ApplicationID"
    t.index ["ApplicationID"], name: "fk_application"
  end

  create_table "Suburbs", primary_key: "SuburbID", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "DisplayName", null: false
    t.text "Suburb", null: false
    t.text "State", null: false
    t.text "Postcode", null: false
  end

  create_table "Uploaded", primary_key: "UploadedId", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "UploadedDate"
    t.text "UploadedText"
    t.integer "ApplicationID"
    t.index ["ApplicationID"], name: "fk_application"
  end

  add_foreign_key "AdditionalInfo", "Applications", column: "ApplicationID", primary_key: "ApplicationID", name: "AdditionalInfo_ibfk_1"
  add_foreign_key "Applications", "ApplicationTypes", column: "ApplicationType", primary_key: "ApplicationType", name: "fk_type"
  add_foreign_key "Applications", "Clients", column: "ApplicantID", primary_key: "ClientID", name: "fk_applicant"
  add_foreign_key "Applications", "Clients", column: "CareOfID", primary_key: "ClientID", name: "Applications_ibfk_3"
  add_foreign_key "Applications", "Clients", column: "ClientID", primary_key: "ClientID", name: "fk_client"
  add_foreign_key "Applications", "Clients", column: "InvoiceToID", primary_key: "ClientID", name: "Applications_ibfk_2"
  add_foreign_key "Applications", "Clients", column: "OwnerID", primary_key: "ClientID", name: "fk_owner"
  add_foreign_key "Applications", "Councils", column: "ApplicantCouncilID", primary_key: "CouncilID", name: "fk_applicant_council"
  add_foreign_key "Applications", "Councils", column: "ClientCouncilID", primary_key: "CouncilID", name: "fk_client_council"
  add_foreign_key "Applications", "Councils", column: "CouncilID", primary_key: "CouncilID", name: "fk_council"
  add_foreign_key "Applications", "Councils", column: "OwnerCouncilID", primary_key: "CouncilID", name: "fk_owner_council"
  add_foreign_key "Applications", "Suburbs", column: "SuburbID", primary_key: "SuburbID", name: "Applications_ibfk_1"
  add_foreign_key "Clients", "Suburbs", column: "PostalSuburbID", primary_key: "SuburbID", name: "Clients_ibfk_2"
  add_foreign_key "Clients", "Suburbs", column: "SuburbID", primary_key: "SuburbID", name: "Clients_ibfk_1"
  add_foreign_key "Councils", "Suburbs", column: "PostalSuburbID", primary_key: "SuburbID", name: "Councils_ibfk_2"
  add_foreign_key "Councils", "Suburbs", column: "SuburbID", primary_key: "SuburbID", name: "Councils_ibfk_1"
  add_foreign_key "Invoices", "Applications", column: "ApplicationID", primary_key: "ApplicationID", name: "Invoices_ibfk_1"
  add_foreign_key "Stages", "Applications", column: "ApplicationID", primary_key: "ApplicationID", name: "Stages_ibfk_1"
  add_foreign_key "Uploaded", "Applications", column: "ApplicationID", primary_key: "ApplicationID", name: "Uploaded_ibfk_1"
end
