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

ActiveRecord::Schema[7.0].define(version: 2022_11_28_131140) do
  create_table "application_additional_informations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.date "info_date"
    t.text "info_text"
    t.integer "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "application_types", charset: "utf8", force: :cascade do |t|
    t.string "application_type", limit: 10, null: false
    t.integer "last_used", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "application_uploads", id: :integer, charset: "utf8", force: :cascade do |t|
    t.date "uploaded_date"
    t.text "uploaded_text"
    t.integer "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "applications", id: :integer, charset: "utf8", force: :cascade do |t|
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
    t.integer "number_of_storeys"
    t.decimal "construction_value", precision: 13, scale: 2
    t.decimal "fee_amount", precision: 13, scale: 2
    t.text "building_surveyor"
    t.text "structural_engineer"
    t.text "risk_rating"
    t.date "assessment_commenced"
    t.date "request_for_information_issued"
    t.date "consent_issued"
    t.date "variation_issued"
    t.date "coo_issued"
    t.text "job_type"
    t.text "consent"
    t.text "certifier"
    t.date "engineer_certificate_received"
    t.text "certification_notes"
    t.text "invoice_to"
    t.text "care_of"
    t.text "invoice_email"
    t.text "attention"
    t.text "purchase_order_number"
    t.boolean "fully_invoiced", default: false
    t.text "invoice_debtor_notes"
    t.text "applicant_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "application_type_id"
    t.date "external_engineer_date"
    t.index ["applicant_council_id"], name: "fk_applicant_council"
    t.index ["applicant_id"], name: "fk_applicant"
    t.index ["application_type_id"], name: "index_applications_on_application_type_id"
    t.index ["client_council_id"], name: "fk_client_council"
    t.index ["client_id"], name: "fk_client"
    t.index ["converted_to_from"], name: "index_applications_on_converted_to_from", type: :fulltext
    t.index ["council_id"], name: "fk_council"
    t.index ["description", "development_application_number", "street_name", "street_number", "lot_number"], name: "application_search_fulltext_index", type: :fulltext
    t.index ["owner_council_id"], name: "fk_owner_council"
    t.index ["owner_id"], name: "fk_owner"
    t.index ["reference_number"], name: "index_applications_on_reference_number", type: :fulltext
    t.index ["suburb_id"], name: "fk_suburb"
  end

  create_table "clients", id: :integer, charset: "utf8", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_name"], name: "index_clients_on_client_name", type: :fulltext
    t.index ["postal_suburb_id"], name: "fk_postalsuburb"
    t.index ["suburb_id"], name: "fk_suburb"
  end

  create_table "councils", id: :integer, charset: "utf8", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_councils_on_name", type: :fulltext
    t.index ["postal_suburb_id"], name: "fk_postalsuburb"
    t.index ["suburb_id"], name: "fk_suburb"
  end

  create_table "invoices", id: :integer, charset: "utf8", force: :cascade do |t|
    t.text "invoice_number"
    t.text "stage"
    t.decimal "fee", precision: 13, scale: 2
    t.decimal "gst", precision: 13, scale: 2
    t.decimal "admin_fee", precision: 13, scale: 2
    t.decimal "dac", precision: 13, scale: 2
    t.decimal "lodgement", precision: 13, scale: 2
    t.decimal "insurance_levy", precision: 13, scale: 2
    t.date "invoice_date"
    t.boolean "paid"
    t.integer "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "request_for_informations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "request_for_information_date"
    t.integer "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "fk_rails_dde47abfd9"
  end

  create_table "stages", id: :integer, charset: "utf8", force: :cascade do |t|
    t.date "stage_date"
    t.text "stage_text"
    t.integer "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "fk_application"
  end

  create_table "suburbs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.text "display_name", null: false
    t.text "suburb", null: false
    t.text "state", null: false
    t.text "postcode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_suburbs_on_display_name", type: :fulltext
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "application_additional_informations", "applications", name: "application_additional_informations_ibfk_1", on_delete: :cascade
  add_foreign_key "application_uploads", "applications", name: "application_uploads_ibfk_1", on_delete: :cascade
  add_foreign_key "applications", "application_types"
  add_foreign_key "applications", "clients", column: "applicant_id", name: "fk_applicant", on_delete: :nullify
  add_foreign_key "applications", "clients", column: "owner_id", name: "fk_owner", on_delete: :nullify
  add_foreign_key "applications", "clients", name: "fk_client", on_delete: :nullify
  add_foreign_key "applications", "councils", column: "applicant_council_id", name: "fk_applicant_council", on_delete: :nullify
  add_foreign_key "applications", "councils", column: "client_council_id", name: "fk_client_council", on_delete: :nullify
  add_foreign_key "applications", "councils", column: "owner_council_id", name: "fk_owner_council", on_delete: :nullify
  add_foreign_key "applications", "councils", name: "fk_council", on_delete: :nullify
  add_foreign_key "applications", "suburbs", name: "applications_ibfk_1"
  add_foreign_key "clients", "suburbs", column: "postal_suburb_id", name: "clients_ibfk_2"
  add_foreign_key "clients", "suburbs", name: "clients_ibfk_1"
  add_foreign_key "councils", "suburbs", column: "postal_suburb_id", name: "councils_ibfk_2"
  add_foreign_key "councils", "suburbs", name: "councils_ibfk_1"
  add_foreign_key "invoices", "applications", name: "invoices_ibfk_1", on_delete: :cascade
  add_foreign_key "request_for_informations", "applications", on_delete: :cascade
  add_foreign_key "stages", "applications", name: "stages_ibfk_1", on_delete: :cascade

  create_view "application_search_results", sql_definition: <<-SQL
      select `a`.`id` AS `id`,`t`.`application_type` AS `application_type`,`a`.`reference_number` AS `reference_number`,`a`.`converted_to_from` AS `converted_to_from`,`a`.`street_number` AS `street_number`,`a`.`lot_number` AS `lot_number`,`a`.`street_name` AS `street_name`,concat(if((`a`.`lot_number` is null),'',concat(`a`.`lot_number`,' ')),if((`a`.`street_number` is null),'',concat(`a`.`street_number`,' ')),`a`.`street_name`) AS `location`,`s`.`display_name` AS `suburb`,`a`.`description` AS `description`,`contact`.`client_name` AS `contact`,`owner`.`client_name` AS `owner`,`applicant`.`client_name` AS `applicant`,`council`.`name` AS `council`,`a`.`created_at` AS `created_at`,`a`.`development_application_number` AS `development_application_number` from ((((((`applications` `a` left join `clients` `contact` on((`a`.`client_id` = `contact`.`id`))) left join `clients` `owner` on((`a`.`owner_id` = `owner`.`id`))) left join `clients` `applicant` on((`a`.`applicant_id` = `applicant`.`id`))) left join `councils` `council` on((`a`.`council_id` = `council`.`id`))) left join `application_types` `t` on((`a`.`application_type_id` = `t`.`id`))) left join `suburbs` `s` on((`a`.`suburb_id` = `s`.`id`)))
  SQL
  create_view "applications_csv_results", sql_definition: <<-SQL
      select `a`.`id` AS `id`,`t`.`application_type` AS `application_type`,`a`.`reference_number` AS `reference_number`,`a`.`converted_to_from` AS `converted_to_from`,`council`.`name` AS `council`,`a`.`development_application_number` AS `development_application_number`,`applicant`.`client_name` AS `applicant`,`applicant_c`.`name` AS `applicant_council`,`owner`.`client_name` AS `owner`,`owner_c`.`name` AS `owner_council`,`client`.`client_name` AS `contact`,`client_c`.`name` AS `contact_council`,`a`.`description` AS `description`,`a`.`cancelled` AS `cancelled`,`a`.`street_number` AS `street_number`,`a`.`lot_number` AS `lot_number`,`a`.`street_name` AS `street_name`,`s`.`display_name` AS `suburb`,`a`.`section_93A` AS `section_93A`,`a`.`electronic_lodgement` AS `electronic_lodgement`,`a`.`hard_copy` AS `hard_copy`,`a`.`job_type_administration` AS `job_type_administration`,`a`.`quote_accepted_date` AS `quote_accepted_date`,`a`.`administration_notes` AS `administration_notes`,`a`.`number_of_storeys` AS `number_of_storeys`,`a`.`construction_value` AS `construction_value`,`a`.`fee_amount` AS `fee_amount`,`a`.`building_surveyor` AS `building_surveyor`,`a`.`structural_engineer` AS `structural_engineer`,`a`.`external_engineer_date` AS `external_engineer_date`,`a`.`risk_rating` AS `risk_rating`,`a`.`assessment_commenced` AS `assessment_commenced`,`rfi`.`request_for_information_dates` AS `request_for_information_dates`,`a`.`consent_issued` AS `consent_issued`,`a`.`variation_issued` AS `variation_issued`,`a`.`coo_issued` AS `coo_issued`,`a`.`job_type` AS `job_type`,`a`.`consent` AS `consent`,`a`.`certifier` AS `certifier`,`a`.`engineer_certificate_received` AS `engineer_certificate_received`,`a`.`certification_notes` AS `certification_notes`,`a`.`invoice_to` AS `invoice_to`,`a`.`care_of` AS `care_of`,`a`.`invoice_email` AS `invoice_email`,`a`.`attention` AS `attention`,`a`.`purchase_order_number` AS `purchase_order_number`,`a`.`fully_invoiced` AS `fully_invoiced`,`a`.`invoice_debtor_notes` AS `invoice_debtor_notes`,`a`.`applicant_email` AS `applicant_email`,`a`.`created_at` AS `created_at`,`a`.`updated_at` AS `updated_at` from ((((((((((`applications` `a` left join `application_types` `t` on((`a`.`application_type_id` = `t`.`id`))) left join `suburbs` `s` on((`a`.`suburb_id` = `s`.`id`))) left join `councils` `council` on((`a`.`council_id` = `council`.`id`))) left join `clients` `client` on((`a`.`client_id` = `client`.`id`))) left join `clients` `applicant` on((`a`.`applicant_id` = `applicant`.`id`))) left join `clients` `owner` on((`a`.`owner_id` = `owner`.`id`))) left join `councils` `client_c` on((`a`.`client_council_id` = `client_c`.`id`))) left join `councils` `applicant_c` on((`a`.`applicant_council_id` = `applicant_c`.`id`))) left join `councils` `owner_c` on((`a`.`owner_council_id` = `owner_c`.`id`))) left join (select `request_for_informations`.`application_id` AS `application_id`,group_concat(`request_for_informations`.`request_for_information_date` order by `request_for_informations`.`request_for_information_date` ASC separator ',') AS `request_for_information_dates` from `request_for_informations` group by `request_for_informations`.`application_id`) `rfi` on((`a`.`id` = `rfi`.`application_id`)))
  SQL
end
