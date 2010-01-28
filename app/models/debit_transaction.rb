class DebitTransaction < Transaction
	def amount=(a)
		if a > 0
			self.debit_amount = a
		else
			self.credit_amount = a * -1
		end
	end

	def amount
		self.debit_amount - self.credit_amount
	end
end
