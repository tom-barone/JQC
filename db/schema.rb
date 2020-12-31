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

ActiveRecord::Schema.define(version: 2020_12_31_034522) do

  create_table "application_additional_informations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "info_date"
    t.text "info_text"
    t.integer "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "application_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "application_type", limit: 10, null: false
    t.integer "last_used", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "application_uploads", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "uploaded_date"
    t.text "uploaded_text"
    t.integer "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "applications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "reference_number"
    t.text "converted_to_from"
    t.integer "council_id"
    t.text "development_application_number"
    t.integer "applicant_id"
    t.integer "applicant_council_id"
    t.integer "owner_id"
    t.integer "owner_council_id"
    t.integer "client_id"
    t.integer "client_council_id"
    t.text "description"
    t.boolean "cancelled", default: false
    t.text "street_number"
    t.text "lot_number"
    t.text "street_name"
    t.integer "suburb_id"
    t.date "section_93A"
    t.boolean "electronic_lodgement", default: false
    t.boolean "hard_copy", default: false
    t.text "job_type_administration"
    t.date "quote_accepted_date"
    t.text "administration_notes"
    t.decimal "fee_amount", precision: 13, scale: 2
    t.text "building_surveyor"
    t.text "structural_engineer"
    t.text "risk_rating"
    t.date "assesment_commenced"
    t.date "request_for_information_issued"
    t.date "consent_issued"
    t.date "variation_issued"
    t.date "staged"
    t.date "coo_issued"
    t.text "job_type"
    t.text "consent"
    t.text "certifier"
    t.text "certification_notes"
    t.text "invoice_to"
    t.text "care_of"
    t.text "invoice_email"
    t.text "attention"
    t.text "purchase_order_number"
    t.boolean "fully_invoiced", default: false
    t.text "invoice_debtor_notes"
    t.text "applicant_email"
    t.integer "sort_priority_gen", limit: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "application_type_id"
    t.index ["applicant_council_id"], name: "fk_applicant_council"
    t.index ["applicant_id"], name: "fk_applicant"
    t.index ["application_type_id"], name: "index_applications_on_application_type_id"
    t.index ["client_council_id"], name: "fk_client_council"
    t.index ["client_id"], name: "fk_client"
    t.index ["council_id"], name: "fk_council"
    t.index ["description", "development_application_number", "street_name", "street_number", "lot_number"], name: "application_search_fulltext_index", type: :fulltext
    t.index ["owner_council_id"], name: "fk_owner_council"
    t.index ["owner_id"], name: "fk_owner"
    t.index ["suburb_id"], name: "fk_suburb"
  end

  create_table "clients", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "client_type"
    t.text "client_name"
    t.text "first_name"
    t.text "surname"
    t.text "title"
    t.text "initials"
    t.text "salutation"
    t.text "company_name"
    t.text "street"
    t.integer "suburb_id"
    t.text "postal_address"
    t.integer "postal_suburb_id"
    t.text "australian_business_number"
    t.string "state", limit: 10
    t.text "phone"
    t.text "mobile_number"
    t.text "fax"
    t.text "email"
    t.text "notes"
    t.boolean "bad_payer", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_name"], name: "index_clients_on_client_name", type: :fulltext
    t.index ["postal_suburb_id"], name: "fk_postalsuburb"
    t.index ["suburb_id"], name: "fk_suburb"
  end

  create_table "councils", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name"
    t.text "city"
    t.text "street"
    t.string "state", limit: 10
    t.integer "suburb_id"
    t.text "postal_address"
    t.integer "postal_suburb_id"
    t.text "phone"
    t.text "fax"
    t.text "email"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_councils_on_name", type: :fulltext
    t.index ["postal_suburb_id"], name: "fk_postalsuburb"
    t.index ["suburb_id"], name: "fk_suburb"
  end

  create_table "invoices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "invoice_number"
    t.text "stage"
    t.decimal "fee", precision: 13, scale: 2
    t.decimal "gst", precision: 13, scale: 2
    t.decimal "dac", precision: 13, scale: 2
    t.decimal "lodgement", precision: 13, scale: 2
    t.decimal "insurance_levy", precision: 13, scale: 2
    t.decimal "percent_invoiced", precision: 13, scale: 2
    t.date "invoice_date"
    t.boolean "paid"
    t.integer "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "stages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "stage_date"
    t.text "stage_text"
    t.integer "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "suburbs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "display_name", null: false
    t.text "suburb", null: false
    t.text "state", null: false
    t.text "postcode", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["display_name"], name: "index_suburbs_on_display_name", type: :fulltext
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "application_additional_informations", "applications", name: "application_additional_informations_ibfk_1", on_delete: :cascade
  add_foreign_key "application_uploads", "applications", name: "application_uploads_ibfk_1", on_delete: :cascade
  add_foreign_key "applications", "application_types"
  add_foreign_key "applications", "clients", column: "applicant_id", name: "fk_applicant"
  add_foreign_key "applications", "clients", column: "owner_id", name: "fk_owner"
  add_foreign_key "applications", "clients", name: "fk_client"
  add_foreign_key "applications", "councils", column: "applicant_council_id", name: "fk_applicant_council"
  add_foreign_key "applications", "councils", column: "client_council_id", name: "fk_client_council"
  add_foreign_key "applications", "councils", column: "owner_council_id", name: "fk_owner_council"
  add_foreign_key "applications", "councils", name: "fk_council"
  add_foreign_key "applications", "suburbs", name: "applications_ibfk_1"
  add_foreign_key "clients", "suburbs", column: "postal_suburb_id", name: "clients_ibfk_2"
  add_foreign_key "clients", "suburbs", name: "clients_ibfk_1"
  add_foreign_key "councils", "suburbs", column: "postal_suburb_id", name: "councils_ibfk_2"
  add_foreign_key "councils", "suburbs", name: "councils_ibfk_1"
  add_foreign_key "invoices", "applications", name: "invoices_ibfk_1", on_delete: :cascade
  add_foreign_key "stages", "applications", name: "stages_ibfk_1", on_delete: :cascade
end
