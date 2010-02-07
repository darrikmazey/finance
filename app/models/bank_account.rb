class BankAccount < AssetAccount

	def div_classes
		f = super
		f << 'bank_account'
	end


end
