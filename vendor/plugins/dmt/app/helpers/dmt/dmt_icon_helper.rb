module Dmt
	module DmtIconHelper
		def icon_theme_name
			#'gion'
			'icons/phoenity'
		end

		def icon_default_size
			:small
		end
		def show_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/show_' + size_str + '.png', :alt => 'show', :title => 'show'
		end

		def edit_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/edit_' + size_str + '.png', :alt => 'edit', :title => 'edit'
		end

		def delete_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/delete_' + size_str + '.png', :alt => 'delete', :title => 'delete'
		end

		def back_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/back_' + size_str + '.png', :alt => 'back', :title => 'back'
		end
		
		def new_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/new_' + size_str + '.png', :alt => 'new', :title => 'new'
		end

		def pdf_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/pdf_' + size_str + '.png', :alt => 'pdf', :title => 'pdf'
		end

		def check_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/check_' + size_str + '.png', :alt => 'check', :title => 'check'
		end

		def blank_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/blank_' + size_str + '.png', :alt => 'blank', :title => 'blank'
		end

		def comment_image_tag(size = icon_default_size)
			size_str = '16'
			if size == :large
				size_str = '24'
			end
			image_tag icon_theme_name + '/comment_' + size_str + '.png', :alt => 'comment', :title => 'comment'
		end
	end
end
