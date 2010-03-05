class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}) 
    text = text || method.to_s.humanize
    text += ":"
    return "<div class='form_field_label'>#{super(method, text, options)}</div>"
  end

  def password_field(method, options = {})
    generate_form_field(method, super(method, options), options)
  end

  def text_field(method, options = {}) 
    generate_form_field(method, super(method, options), options)
  end

  def text_area(method, options = {}) 
    generate_form_field(method, super(method, options), options)
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    generate_form_field(method, super(method, collection, value_method, text_method, options, html_options), options)
  end 

	def check_box(method, options = {})
		generate_form_field(method, super(method, options), options)
	end

  def select(method, choices, options = {}, html_options = {})
    generate_form_field(method, super(method, choices, options, html_options), options)
  end

  def datetime_select(method, options = {}, html_options = {})
    generate_form_field(method, super(method, options, html_options), options)
  end

  def date_select(method, options = {}, html_options = {})
    generate_form_field(method, super(method, options, html_options), options)
  end

  def submit(value, options = {}) 
    return "<div class='form_button'>#{super(value, options)}</div>"
  end

  private

  # takes the params for a form field and the code for the actual field 
  # and creates the entire package
  def generate_form_field(method, super_code, options)
    return super_code if options[:no_label]
    return "\ 
      <div class='form_line'> \
        #{generate_label(method, options)} \
        <div class='form_field'> \
          #{super_code} \ 
          #{generate_error(method, options)} \
        </div> \
      </div>"
  end

  # generates the label for a form field
  def generate_label(method, options)
    label_text = method.to_s.humanize
    label_text = options[:label] if options[:label]
    label = ''
    if (options[:label] && options[:label] != '') || !options[:label]
      label = label(method, label_text, {})
    end 
    return label
  end

  # generates the error code for a form field
  def generate_error(method, options)
    object = @template.instance_variable_get("@#{@object_name}") rescue nil
    error_text = ''
    unless object.nil? || options[:hide_errors]
      errors = object.errors.on(method.to_sym)
      if errors
        error_text += " <span class=\"error\">#{errors.is_a?(Array) ? errors.first: errors}</span>"
      end
    end 
    return error_text
  end
end
