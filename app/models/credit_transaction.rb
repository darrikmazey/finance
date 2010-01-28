class CreditTransaction < Transaction
	def amount=(a)
		if a > 0
			self.credit_amount = a
		else
			self.debit_amount = a * -1
		end
	end

	def amount
		self.credit_amount - self.debit_amount
	end
end
