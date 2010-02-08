class CapitalAccount < Account

	def after_initialize
		@increasing = :credit
	end

	def div_classes
		f = super
		f << 'capital_account'
	end

	def capital?
		true
	end

end
