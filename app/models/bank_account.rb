class BankAccount < DebitAccount

	def self.hidden_fields
		[]
	end

	def is_endpoint?
		false
	end
end
