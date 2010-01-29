class BankAccount < DebitAccount

	def self.hidden_fields
		[ :amount, :due_date, :period ]
	end

end
