class AssetAccount < Account

	def after_initialize
		@increasing = :debit
	end

	def div_classes
		f = super
		f << 'asset_account'
	end

	def asset?
		true
	end

end
