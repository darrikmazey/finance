module Dmt
	module DmtHelper

		def redirect_back_or(options = {}, response_status = {})
			if request.env.has_key?('HTTP_REFERER')
				redirect_to request.env['HTTP_REFERER']
			else
				redirect_to options, response_status
			end
		end

	end
end
