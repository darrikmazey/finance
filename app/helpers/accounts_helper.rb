module AccountsHelper
	def convert_period(amount, from, to)
		amount * from / to
	end
end
