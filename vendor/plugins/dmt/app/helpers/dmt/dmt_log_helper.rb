module Dmt
	module DmtLogHelper

		def log(line)
			RAILS_DEFAULT_LOGGER.error('================')
			RAILS_DEFAULT_LOGGER.error(line.to_s)
			RAILS_DEFAULT_LOGGER.error('================')
		end

	end
end
