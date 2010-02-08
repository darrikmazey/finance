class EquityAccount < CapitalAccount

	def after_initialize
		@increasing = :credit
	end

	def div_classes
		f = super
		f << 'equity_account'
	end

	def equity?
		true
	end

end
