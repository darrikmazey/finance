require 'account.rb'
require 'credit.rb'

class Client < Credit

	def hours_client
		self.reference_object
	end
end
