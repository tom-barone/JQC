# frozen_string_literal: true

module Applications
  module EditPageObject
    # Navigation
    EXIT_BUTTON = 'Exit'
    EXIT_CONFIRM = 'OK'
    EXIT_CANCEL = 'Cancel'
    SAVE_BUTTON = 'Save'

    APPLICATION_TYPE_SELECT = 'Type'

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

    def select_application_type(value)
      select value, from: APPLICATION_TYPE_SELECT
    end

    # Dynamically define methods for each input field
    INPUT_FIELDS.each do |field, selector|
      define_method("fill_in_#{field}") do |value|
        fill_in selector, with: value
      end

      define_method("assert_#{field}") do |value|
        assert_field selector, with: value
      end
    end

    def click_exit
      click_on EXIT_BUTTON
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
