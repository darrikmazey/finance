class CapitalAccount < Account
	def div_classes
		f = super
		f << 'capital_account'
	end

	def capital?
		true
	end

	def balance
		initial_balance + credit_sum - debit_sum
	end
end
