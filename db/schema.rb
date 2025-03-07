# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_06_231800) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "application_additional_informations", id: :serial, force: :cascade do |t|
    t.date "info_date"
    t.text "info_text"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_additional_informations_on_application_id"
  end

  create_table "application_types", id: :serial, force: :cascade do |t|
    t.text "application_type", null: false
    t.integer "last_used", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_priority", default: 0
    t.boolean "active", default: true, null: false
  end

  create_table "application_uploads", id: :serial, force: :cascade do |t|
    t.date "uploaded_date"
    t.text "uploaded_text"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_uploads_on_application_id"
  end

  create_table "applications", id: :serial, force: :cascade do |t|
    t.text "reference_number", null: false
    t.text "converted_to_from"
    t.bigint "council_id"
    t.text "development_application_number"
    t.bigint "applicant_id"
    t.bigint "owner_id"
    t.bigint "contact_id"
    t.text "description"
    t.boolean "cancelled", default: false, null: false
    t.text "street_number"
    t.text "lot_number"
    t.text "street_name"
    t.bigint "suburb_id"
    t.boolean "electronic_lodgement", default: false, null: false
    t.boolean "engagement_form", default: false, null: false
    t.text "job_type_administration"
    t.date "quote_accepted_date"
    t.text "administration_notes"
    t.integer "number_of_storeys"
    t.decimal "construction_value", precision: 13, scale: 2
    t.decimal "fee_amount", precision: 13, scale: 2
    t.text "building_surveyor"
    t.text "risk_rating"
    t.date "assessment_commenced"
    t.date "consent_issued"
    t.date "coo_issued"
    t.text "certifier"
    t.text "certification_notes"
    t.text "invoice_to"
    t.text "care_of"
    t.text "invoice_email"
    t.text "attention"
    t.text "purchase_order_number"
    t.boolean "fully_invoiced", default: false, null: false
    t.text "invoice_debtor_notes"
    t.text "applicant_email"
    t.bigint "application_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "location", type: :string, as: "((COALESCE((lot_number || ' '::text), ''::text) || COALESCE((street_number || ' '::text), ''::text)) || street_name)", stored: true
    t.tsvector "searchable_tsvector"
    t.boolean "staged_consent", default: false, null: false
    t.decimal "area_m2", precision: 13, scale: 2
    t.boolean "construction_industry_trading_board", default: false, null: false
    t.boolean "kd_to_lodge", default: false, null: false
    t.boolean "variation_requested", default: false, null: false
    t.index ["applicant_id"], name: "index_applications_on_applicant_id"
    t.index ["application_type_id"], name: "index_applications_on_application_type_id"
    t.index ["contact_id"], name: "index_applications_on_contact_id"
    t.index ["council_id"], name: "index_applications_on_council_id"
    t.index ["owner_id"], name: "index_applications_on_owner_id"
    t.index ["searchable_tsvector"], name: "applications_searchable_idx", using: :gin
    t.index ["suburb_id"], name: "index_applications_on_suburb_id"
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.text "client_type"
    t.text "client_name"
    t.text "first_name"
    t.text "surname"
    t.text "title"
    t.text "initials"
    t.text "salutation"
    t.text "company_name"
    t.text "street"
    t.text "postal_address"
    t.text "australian_business_number"
    t.text "state"
    t.text "phone"
    t.text "mobile_number"
    t.text "fax"
    t.text "email"
    t.text "notes"
    t.boolean "bad_payer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "suburb_id"
    t.bigint "postal_suburb_id"
    t.index ["postal_suburb_id"], name: "index_clients_on_postal_suburb_id"
    t.index ["suburb_id"], name: "index_clients_on_suburb_id"
  end

  create_table "consultancies", force: :cascade do |t|
    t.text "consultancy_type"
    t.date "scheduled_date"
    t.text "notes"
    t.date "report_or_email_sent"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_consultancies_on_application_id"
  end

  create_table "councils", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "city"
    t.text "street"
    t.text "state"
    t.bigint "suburb_id"
    t.text "postal_address"
    t.bigint "postal_suburb_id"
    t.text "phone"
    t.text "fax"
    t.text "email"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postal_suburb_id"], name: "index_councils_on_postal_suburb_id"
    t.index ["suburb_id"], name: "index_councils_on_suburb_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.text "invoice_number"
    t.text "stage"
    t.decimal "fee", precision: 13, scale: 2
    t.decimal "gst", precision: 13, scale: 2
    t.decimal "admin_fee", precision: 13, scale: 2
    t.date "invoice_date"
    t.boolean "paid", default: false, null: false
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_invoices_on_application_id"
  end

  create_table "request_for_informations", id: :serial, force: :cascade do |t|
    t.date "request_for_information_date"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_request_for_informations_on_application_id"
  end

  create_table "stages", id: :serial, force: :cascade do |t|
    t.date "stage_date"
    t.text "stage_text"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "stage_notes"
    t.index ["application_id"], name: "index_stages_on_application_id"
  end

  create_table "structural_engineers", force: :cascade do |t|
    t.text "structural_engineer"
    t.date "external_engineer_date"
    t.decimal "structural_engineer_fee", precision: 13, scale: 2
    t.date "engineer_certificate_received"
    t.text "certificate_reference"
    t.boolean "structural_engineer_ok_to_pay", default: false, null: false
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_structural_engineers_on_application_id"
  end

  create_table "suburbs", id: :serial, force: :cascade do |t|
    t.text "suburb", null: false
    t.text "state", null: false
    t.text "postcode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "display_name", type: :string, as: "((((suburb || ', '::text) || state) || ' '::text) || postcode)", stored: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "variations", force: :cascade do |t|
    t.date "variation_date"
    t.text "variation_type"
    t.date "variation_issued"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_variations_on_application_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "application_additional_informations", "applications"
  add_foreign_key "application_uploads", "applications"
  add_foreign_key "applications", "application_types"
  add_foreign_key "applications", "clients", column: "applicant_id"
  add_foreign_key "applications", "clients", column: "contact_id"
  add_foreign_key "applications", "clients", column: "owner_id"
  add_foreign_key "applications", "councils"
  add_foreign_key "applications", "suburbs"
  add_foreign_key "clients", "suburbs"
  add_foreign_key "clients", "suburbs", column: "postal_suburb_id"
  add_foreign_key "consultancies", "applications"
  add_foreign_key "councils", "suburbs"
  add_foreign_key "councils", "suburbs", column: "postal_suburb_id"
  add_foreign_key "invoices", "applications"
  add_foreign_key "request_for_informations", "applications"
  add_foreign_key "stages", "applications"
  add_foreign_key "structural_engineers", "applications"
  add_foreign_key "variations", "applications"
end
