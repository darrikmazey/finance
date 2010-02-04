class LiabilityAccount < Account
	def div_classes
		f = super
		f << 'liability_account'
	end
end
