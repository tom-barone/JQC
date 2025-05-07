# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength, Metrics/ClassLength, Metrics/AbcSize
class CreateAllTablesFromMysql < ActiveRecord::Migration[8.0]
  def change
    create_table :suburbs, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.text :suburb, null: false
      t.text :state, null: false
      t.text :postcode, null: false
      t.timestamps null: false
    end

    create_table :clients, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.text :client_type
      t.text :client_name
      t.text :first_name
      t.text :surname
      t.text :title
      t.text :initials
      t.text :salutation
      t.text :company_name
      t.text :street
      t.text :postal_address
      t.text :australian_business_number
      t.text :state
      t.text :phone
      t.text :mobile_number
      t.text :fax
      t.text :email
      t.text :notes
      t.boolean :bad_payer, default: false, null: false
      t.timestamps null: false

      t.references :suburb, foreign_key: true
      t.references :postal_suburb, foreign_key: { to_table: :suburbs }
    end

    create_table :councils, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.text :name
      t.text :city
      t.text :street
      t.text :state
      t.references :suburb, foreign_key: true
      t.text :postal_address
      t.references :postal_suburb, foreign_key: { to_table: :suburbs }
      t.text :phone
      t.text :fax
      t.text :email
      t.text :notes
      t.timestamps null: false
    end

    create_table :application_types, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.text :application_type, null: false
      t.integer :last_used, null: false
      t.timestamps null: false
    end

    create_table :applications, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.text :reference_number, null: false
      t.text :converted_to_from
      t.references :council, foreign_key: true
      t.text :development_application_number
      t.references :applicant, foreign_key: { to_table: :clients }
      t.references :owner, foreign_key: { to_table: :clients }
      t.references :contact, foreign_key: { to_table: :clients }
      t.text :description
      t.boolean :cancelled, default: false, null: false
      t.text :street_number
      t.text :lot_number
      t.text :street_name
      t.references :suburb, foreign_key: true
      t.boolean :electronic_lodgement, default: false, null: false
      t.boolean :engagement_form, default: false, null: false
      t.text :job_type_administration
      t.date :quote_accepted_date
      t.text :administration_notes
      t.integer :number_of_storeys
      t.decimal :construction_value, precision: 13, scale: 2
      t.decimal :fee_amount, precision: 13, scale: 2
      t.text :building_surveyor
      t.text :structural_engineer
      t.text :risk_rating
      t.date :consultancies_review_inspection
      t.date :consultancies_report_sent
      t.date :assessment_commenced
      t.date :consent_issued
      t.date :variation_issued
      t.date :coo_issued
      t.date :engineer_certificate_received
      t.text :certifier
      t.text :certification_notes
      t.text :invoice_to
      t.text :care_of
      t.text :invoice_email
      t.text :attention
      t.text :purchase_order_number
      t.boolean :fully_invoiced, default: false, null: false
      t.text :invoice_debtor_notes
      t.text :applicant_email
      t.references :application_type, foreign_key: true
      t.date :external_engineer_date
      t.timestamps null: false
    end

    create_table :application_additional_informations, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.date :info_date
      t.text :info_text
      t.references :application, foreign_key: true
      t.timestamps null: false
    end

    create_table :application_uploads, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.date :uploaded_date
      t.text :uploaded_text
      t.references :application, foreign_key: true
      t.timestamps null: false
    end

    create_table :invoices, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.text :invoice_number
      t.text :stage
      t.decimal :fee, precision: 13, scale: 2
      t.decimal :gst, precision: 13, scale: 2
      t.decimal :admin_fee, precision: 13, scale: 2
      t.date :invoice_date
      t.boolean :paid, default: false, null: false
      t.references :application, foreign_key: true
      t.timestamps null: false
    end

    create_table :request_for_informations, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.date :request_for_information_date
      t.references :application, foreign_key: true
      t.timestamps null: false
    end

    create_table :stages, id: :integer, charset: 'utf8', force: :cascade do |t|
      t.date :stage_date
      t.text :stage_text
      t.references :application, foreign_key: true
      t.timestamps null: false
    end

    # Seed the ApplicationTypes table
    %w[C LG PC Q RC SC].each do |type|
      ApplicationType.create(application_type: type, last_used: 0)
    end
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/ClassLength, Metrics/AbcSize
