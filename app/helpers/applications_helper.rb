# frozen_string_literal: true

require 'pagy/extras/bootstrap'

module ApplicationsHelper
  def bootstrap_form_with(**options, &)
    options[:builder] = BootstrapFormBuilder
    form_with(**options, &)
  end
end
