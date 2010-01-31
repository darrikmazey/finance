class ClientAccount < CreditAccount
	has_one :client

	def has_client?
		true
	end

	def is_endpoint?
		true
	end
end
