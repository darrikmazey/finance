class CapitalAccount < Account
	def div_classes
		f = super
		f << 'capital_account'
	end

	def capital?
		true
	end
end
