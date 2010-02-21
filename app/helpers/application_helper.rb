# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def accounts_options_for_select(selected_id = nil)
		option_tags = Array.new
		@current_user.accounts.root.each do |a|
			option_tags << "<option value=\"#{a.id}\" #{account_selected(a.id, selected_id)}>#{a.name}</option>"
			if a.children.size > 0
				option_tags << "<optgroup>"
				option_tags << options_from_account(a, selected_id)
				option_tags << "</optgroup>"
			end
		end
		option_tags.flatten.join
	end

	def options_from_account(account, selected_id = nil)
		option_tags = Array.new
		account.children.each do |c|
			option_tags << "<option value=\"#{c.id}\" #{account_selected(c.id, selected_id)}>#{c.name}</option>"
			if c.children.size > 0
				option_tags << options_from_account(c)
			end
		end
		option_tags
	end

	def account_selected(aid, sid)
		if aid == sid
			'selected'
		else
			''
		end
	end

  def form_builder_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array, *(args << options.merge(:builder => CustomFormBuilder)), &proc)
  end

  def custom_fields_for(obj, options = {})
    header = options.delete(:header) || :name
    header = obj.send(header) if header.is_a?(Symbol)
    options[:builder] = FinanceFieldBuilder unless options[:builder]
    
    concat("<div class=\"heading\">#{obj.class.name.titleize} : #{header}</div>
      <div class=\"content\">")
    yield CustomFields.new(obj, options)
    concat("</div>")
  end
end
