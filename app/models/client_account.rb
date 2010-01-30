class ClientAccount < CreditAccount
	has_one :client

	def is_endpoint?
		true
	end
end
