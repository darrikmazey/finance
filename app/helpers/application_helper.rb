# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  ActionView::Base.default_form_builder = CustomFormBuilder

	def accounts_options_for_select(selected_id = nil)
		option_tags = Array.new
		@user_options.account_group.accounts.root.each do |a|
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

  def my_custom_fields_for(obj, options = {}, &block)
    options[:builder] = FinanceFieldBuilder.new unless options[:builder]
    custom_fields_for(obj, options, &block)
  end

  def admin?
    logged_in? && @current_user.admin?
  end

  def admin_account_group?
    logged_in? && (@current_user.admin? || @user_options.admin_account_group?)
  end

  def button_link_to(text, url, options = {})
    "<div class=\"button_link\">#{link_to text, url, options}</div>"
  end

  def admin_account_group_link_to(text, url, options = {})
    link_to(text, url, options) if @current_user.admin? || @user_options.admin_account_group?
  end

  def display_menu_item(item)
    ret = ""
    ret += "<li #{item.children ? "class=\"dir\"" : ""}>"
    ret += item.url ? link_to(item.name, item.url) : item.name
    ret += " #{link_to('+', item.new_path, { :class => 'new_link' }) }" if item.new_path
    if item.children
      ret += "<ul>"
      item.children.each { |child|
        ret += display_menu_item(child)
      }
      ret += "</ul>"
    end
    ret += "</li>"
    ret
  end
end
