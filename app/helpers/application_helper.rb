# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def accounts_options_for_select
		option_tags = Array.new
		@current_user.accounts.root.each do |a|
			option_tags << "<option value=\"#{a.id}\">#{a.name}</option>"
			if a.children.size > 0
				option_tags << "<optgroup>"
				option_tags << options_from_account(a)
				option_tags << "</optgroup>"
			end
		end
		option_tags.flatten.join
	end

	def options_from_account(account)
		option_tags = Array.new
		account.children.each do |c|
			option_tags << "<option value=\"#{c.id}\">#{c.name}</option>"
			if c.children.size > 0
				option_tags << options_from_account(c)
			end
		end
		option_tags
	end
end
