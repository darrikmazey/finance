class LiabilityAccount < Account

	def after_initialize
		@increasing = :credit
	end

	def div_classes
		f = super
		f << 'liability_account'
	end

	def positive?
		balance > 0
	end

end
