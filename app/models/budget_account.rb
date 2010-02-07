class BudgetAccount < AssetAccount

	def div_classes
		f = super
		f << 'budget_account'
	end
end
