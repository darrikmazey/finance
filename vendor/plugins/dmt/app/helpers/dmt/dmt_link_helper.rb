module Dmt
	module DmtLinkHelper

		def secure_link_div(name, options = {}, html_options = nil)
			slt = secure_link_to(name, options, html_options)
			if !slt.nil?
				'<div class="link">' + slt + '</div>'
			else
				nil
			end
		end

		def secure_link_to(name, options = {}, html_options = nil)
			if options.class.to_s == 'String'
				if options == '#'
					options = request.url
				end
				options.sub!(/^http:\/\/(.*?)(:\d+)?\//, '/')
			end
			env = {}
			if html_options.nil? or html_options[:method].nil?
				env[:method] = :get
			else
				env[:method] = html_options[:method]
			end
			route = ActionController::Routing::Routes.recognize_path(url_for(options), env)
			tc = route[:controller].to_s
			ta = route[:action].to_s
			ti = route[:id].to_s
			tm = env[:method].to_s
			#log(tc + ':' + ta + ':' + ti + ':' + tm)
			if !ti.nil?
				begin
					obj = eval(tc.classify.to_s + '.find(' + ti + ')')
				rescue ActiveRecord::RecordNotFound
					obj = nil
				end
				#log('obj == ' + obj.inspect)
			end
			if obj.nil?
				if !Permission.group_access?(@current_user, tc, ta)
					#log('access denied for ' + @current_user.username + ' to ' + tc + ':' + ta)
					return nil
				else
					#log('access granted for ' + @current_user.username + ' to ' + tc + ':' + ta)
					return link_to(name, options, html_options)
				end
			end
			#log('user: ' + @current_user.username + ' ; obj: ' + obj.inspect + ' ; action: ' + ta)
			if !Permission.user_access?(@current_user, obj, ta)
				#log('access denied for ' + @current_user.username + ' to ' + tc + ':' + ta + ':' + ti)
				return nil
			else
				#log('access granted for ' + @current_user.username + ' to ' + tc + ':' + ta + ':' + ti)
				return link_to(name, options, html_options)
			end
		end

	end
end
