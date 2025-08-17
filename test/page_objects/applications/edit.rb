# frozen_string_literal: true

module Applications
  module EditPageObject
    # Navigation
    EXIT_BUTTON = 'Exit'
    EXIT_CONFIRM = 'OK'
    EXIT_CANCEL = 'Cancel'
    SAVE_BUTTON = 'Save'

    # Fields
    APPLICATION_TYPE_SELECT = 'application[application_type_id]'
    REFERENCE_NUMBER_FIELD = 'application[reference_number]'

    def select_application_type(value)
      select value, from: APPLICATION_TYPE_SELECT
    end

    def fill_in_reference_number(value)
      fill_in REFERENCE_NUMBER_FIELD, with: value
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
