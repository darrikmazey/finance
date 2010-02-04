class AssetAccount < Account
	def div_classes
		f = super
		f << 'asset_account'
	end
end
