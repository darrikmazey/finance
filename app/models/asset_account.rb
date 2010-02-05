class AssetAccount < Account
	def div_classes
		f = super
		f << 'asset_account'
	end

	def asset?
		true
	end

	def balance
		initial_balance + debit_sum - credit_sum
	end
end
