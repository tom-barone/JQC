# frozen_string_literal: true

module SettingsPageObject
  SAVE_BUTTON = 'Save'
  EXIT_BUTTON = 'Exit'

  APPLICATION_TYPE_INPUT_FIELDS = {
    last_used_number: 'last_used',
    priority: 'display_priority',
    active: 'active'
  }.freeze

  APPLICATION_TYPE_CHECKBOX_FIELDS = {
    active: 'active'
  }.freeze

  APPLICATION_TYPE_INPUT_FIELDS.each do |field, selector|
    define_method("fill_in_#{field}") do |application_type, value|
      application_type_input = find("input[value=#{application_type}]")
      row = application_type_input.find(:xpath, './ancestor::tr')
      field_input = row.find("input[name$='[#{selector}]']")
      field_input.fill_in with: value
    end
  end

  APPLICATION_TYPE_CHECKBOX_FIELDS.each do |field, selector|
    define_method("set_#{field}") do |application_type, checked|
      application_type_input = find("input[value=#{application_type}]")
      row = application_type_input.find(:xpath, './ancestor::tr')
      field_checkbox = row.find("input[name$='[#{selector}]']")
      field_checkbox.check if checked
      field_checkbox.uncheck unless checked
    end
  end

  def click_save
    click_on SAVE_BUTTON
  end

  def click_exit
    click_on EXIT_BUTTON
  end
end
