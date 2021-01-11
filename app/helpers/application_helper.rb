module ApplicationHelper
  def button_to_add_row(f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields =
      f.simple_fields_for(
        association,
        new_object,
        child_index: id
      ) { |builder| render(association.to_s.singularize, f: builder) }

    "<a href='#' class='#{('add_fields' + ' ' + args[:class]).html_safe}' data-id='#{id}' data-fields='#{fields.gsub("\n", '')}'>
      <svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-plus-circle-fill' viewBox='0 0 16 16'>
        <path d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z'/>
      </svg>
    </a>".html_safe
  end

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
      super(
        method,
        options.reverse_merge(class: 'form-control form-control-sm')
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
