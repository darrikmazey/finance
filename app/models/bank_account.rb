class BankAccount < DebitAccount

	def self.hidden_fields
		[ :due_date, :period ]
	end

end
