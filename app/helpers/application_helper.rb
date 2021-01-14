module ApplicationHelper
  class BootstrapSmallFormBuilder < ActionView::Helpers::FormBuilder
    def collection_select(
      method,
      collection,
      value_method,
      text_method,
      options = {},
      html_options = {}
    )
      super(
        method,
        collection,
        value_method,
        text_method,
        options,
        html_options.reverse_merge(class: 'form-control form-control-sm')
      )
    end

    def select(method, choices = nil, options = {}, html_options = {})
      super(
        method,
        choices,
        options,
        html_options.reverse_merge(class: 'form-control form-control-sm')
      )
    end
    def text_area(method, options = {})
      super(
        method,
        options.reverse_merge(class: 'form-control form-control-sm')
      )
    end
    def check_box(
      method,
      options = {},
      checked_value = '1',
      unchecked_value = '0'
    )
      super(
        method,
        options.reverse_merge(
          class: 'form-check-input',
          style: 'transform:scale(1.5)'
        ),
        checked_value,
        unchecked_value
      )
    end
    def text_field(method, options = {})
      # TODO: make all the field helpers do this
      options[:class] = "#{options[:class]} form-control form-control-sm"
      super(
        method,
        options
      )
    end
    def date_field(method, options = {})
      super(
        method,
        options.reverse_merge(class: 'form-control form-control-sm')
      )
    end
  end
end
