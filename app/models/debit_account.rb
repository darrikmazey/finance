class DebitAccount < Account
	def is_debit_account?
		true
	end

	def positive?
		self.balance >= 0
	end

	def negative?
		!self.positive?
	end
end
