class CreditAccount < Account
	def is_credit_account?
		true
	end

	def positive?
		self.balance <= 0
	end

	def negative?
		!self.positive?
	end
end
