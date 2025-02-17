# frozen_string_literal: true

class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    options[:class] = merge_classes(options[:class], 'form-control form-control-sm')
    super
  end

  def date_field(method, options = {})
    options[:class] = merge_classes(options[:class], 'form-control form-control-sm')
    super
  end

  # rubocop:disable Metrics/ParameterLists
  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    html_options[:class] = merge_classes(html_options[:class], 'form-select form-select-sm')
    super
  end
  # rubocop:enable Metrics/ParameterLists

  def label(method, text = nil, options = {})
    options[:class] = merge_classes(options[:class], 'form-label small mb-0 mt-2')
    super
  end

  def check_box(method, options = {})
    options[:class] = merge_classes(options[:class], 'form-check-input')
    super
  end

  def select(method, choices = nil, options = {}, html_options = {}, &)
    html_options[:class] = merge_classes(html_options[:class], 'form-select form-select-sm')
    options[:include_blank] = true if options[:include_blank].nil?
    super
  end

  private

  def merge_classes(original_classes, new_classes)
    [original_classes, new_classes].compact.join(' ')
  end
end
