# frozen_string_literal: true

require 'pagy/extras/bootstrap'

module ApplicationsHelper
  def bootstrap_form_with(**options, &)
    options[:builder] = BootstrapFormBuilder
    form_with(**options, &)
  end

  def flash_class(level)
    {
      'notice' => 'alert-primary',
      'success' => 'alert-success',
      'warning' => 'alert-warning',
      'error' => 'alert-danger',
      'alert' => 'alert-danger'
    }[level]
  end
end
