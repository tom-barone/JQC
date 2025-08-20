# frozen_string_literal: true

module Applications
  module EditPageObject
    # Navigation
    EXIT_BUTTON = 'Exit'
    EXIT_CONFIRM = 'OK'
    EXIT_CANCEL = 'Cancel'
    SAVE_BUTTON = 'Save'

    # Select Fields
    APPLICATION_TYPE_SELECT = 'application[application_type_id]'

    # Input Fields
    INPUT_FIELDS = {
      reference_number: 'application[reference_number]',
      date_entered: 'application[created_at]'
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
