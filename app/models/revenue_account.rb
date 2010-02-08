class RevenueAccount < CapitalAccount

	def after_initialize
		@increasing = :credit
	end

	def div_classes
		f = super
		f << 'revenue_account'
	end

	def revenue?
		true
	end

end
