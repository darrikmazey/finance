class LiabilityAccount < Account
	def div_classes
		f = super
		f << 'liability_account'
	end

	def liability?
		true
	end

	def positive?
		balance > 0
	end
end
