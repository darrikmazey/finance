class BankAccount < Account

	def self.hidden_fields
		[ :due_date, :period ]
	end

end
