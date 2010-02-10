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

	def revenue_div_flags
		f = Array.new
		if revenue_total >= 0
			f << 'positive'
		else
			f << 'negative'
		end
		f
	end

	def expense_div_flags
		f = Array.new
		if expense_total >= 0
			f << 'negative'
		else
			f << 'positive'
		end
		f
	end

	def net_div_flags
		f = Array.new
		if net >= 0
			f << 'positive'
		else
			f << 'negative'
		end
		f
	end

	def revenue_total
		children.of_type(:revenue).inject(0) { |s,v| s += Period.convert(v.total_amount, v.period, period) }
	end

	def expense_total
		children.of_type(:expense).inject(0) { |s,v| s += Period.convert(v.total_amount, v.period, period) }
	end

	def net
		revenue_total - expense_total
	end
end
