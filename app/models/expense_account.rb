class ExpenseAccount < CapitalAccount

	def after_initialize
		@increasing = :debit
	end

	def expense?
		true
	end

	def div_classes
		f = super
		f << 'expense_account'
	end
end
