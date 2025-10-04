# frozen_string_literal: true

module ApplicationCreateHelper
  def create_new_pc124_and_set_default_fields
    create(:application_type, :pc, last_used: 123)
    sign_in
    click_new_application
    select_application_type('PC')
    fill_in_date_entered(Date.current)
  end
end
