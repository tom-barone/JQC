# frozen_string_literal: true

module Applications
  module EditPageObject
    # Navigation
    EXIT_BUTTON = 'Exit'
    EXIT_CONFIRM = 'OK'
    EXIT_CANCEL = 'Cancel'
    SAVE_BUTTON = 'Save'

    INPUT_FIELDS = {
      reference_number: 'Reference no.',
      date_entered: 'Date entered',
      da_number: 'DA number',
      number_of_storeys: 'Number of storeys',
      construction_value: 'Construction value ($)',
      area: 'Area (m²)',
      fee_amount: 'Fee amount ($)',
      applicant_email: 'Applicant email',
      lot_number: 'Lot number',
      street_number: 'Street number',
      street_name: 'Street name',
      suburb: 'Suburb',
      quote_accepted_date: 'Quote accepted date',
      description: 'Description',
      administration_notes: 'Administration notes',
      invoice_to: 'Invoice to',
      care_of: 'Care of',
      invoice_email: 'Invoice email',
      attention: 'Attention',
      purchase_order_number: 'Purchase No.',
      invoice_debtor_notes: 'Invoice debtor notes'
    }.freeze

    MULTIPLE_INPUT_FIELDS = {
      # Additional information
      info_date: 'info_date',
      info_text: 'info_text'
    }.freeze

    CHECKBOX_FIELDS = {
      kd_to_lodge: 'KD to lodge',
      staged_consent: 'Staged consent?',
      engagement_form: 'Engagement form?',
      cancelled: 'Mark as cancelled'
    }.freeze

    SELECT_FIELDS = {
      application_type: 'Type',
      job_type_administration: 'Job type administration'
    }.freeze

    # Dynamically define methods for each field
    INPUT_FIELDS.each do |field, selector|
      define_method("fill_in_#{field}") do |value|
        fill_in selector, with: value
      end

      define_method("assert_#{field}") do |value|
        assert_field selector, with: value
      end
    end

    CHECKBOX_FIELDS.each do |field, selector|
      define_method("set_#{field}") do |checked|
        check selector if checked
        uncheck selector unless checked
      end

      define_method("assert_#{field}") do |checked|
        assert_checked_field selector if checked
        assert_unchecked_field selector unless checked
      end
    end

    SELECT_FIELDS.each do |field, selector|
      define_method("select_#{field}") do |value|
        select value, from: selector
      end

      define_method("assert_#{field}") do |value|
        assert_field selector, with: value
      end
    end

    MULTIPLE_INPUT_FIELDS.each do |field, selector|
      define_method("all_#{field}") do
        all(:field, selector)
      end
    end

    def click_exit
      click_on EXIT_BUTTON
    end

    def click_add_additional_information
      click_link 'add-additional-information'
    end

    def confirm_exit
      click_on EXIT_CONFIRM
    end

    def cancel_exit
      click_on EXIT_CANCEL
    end

    def click_save
      click_on SAVE_BUTTON
    end

    def click_and_confirm_exit
      click_exit
      confirm_exit
    end
  end
end
