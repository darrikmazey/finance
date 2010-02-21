class FinanceFieldBuilder
  def field(name, value)
    "<div class=\"field first #{name.downcase}\">
      <div class=\"field_name\">#{name.empty? ? "&nbsp;" : name + ":"}</div>
      <div class=\"field_value\">#{value}</div>
    </div>"
  end
end
