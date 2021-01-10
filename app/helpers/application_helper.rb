module ApplicationHelper
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: "add_fields " + args[:class], data: {id: id, fields: fields.gsub("\n", "")})
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
    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      super(
        method,
        options.reverse_merge(class: 'form-check-input'),
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
