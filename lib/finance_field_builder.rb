class FinanceFieldBuilder < Dmt::CustomFields::CustomFieldsView
  def field(name, value)
    "<div class=\"field #{name.downcase}\">
      <div class=\"field_name\">#{name.empty? ? "&nbsp;" : name + ":"}</div>
      <div class=\"field_value\">#{value}</div>
    </div>"
  end

  def before_fields_for(obj, options)
    header = options.delete(:header) || :name
    header = obj.send(header) if header.is_a?(Symbol)
    return "<div class=\"heading\">#{obj.class.name.titleize} : #{header}</div>
      <div class=\"content\">"
  end

  def after_fields_for(obj, options)
    "</div>"
  end
end
