# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def format_date(date)
		if date
			return date.mon.to_s.rjust(2, "0") + "." +
				date.mday.to_s.rjust(2, "0") + "." +
				date.year.to_s;
		else
			return "[no date]"
		end
	end

	def format_currency(amount)
		if amount
			amt = amount.to_s
			# add a zero on to the end of the string if there is only
			# a single decimal digit
			if amt.match(/\.(.*)$/) and amt.match(/\.(.*)$/)[1].length == 1
				amt += "0"
			end
			return "$" + amt
		else
			return "$0.00"
		end
	end
	
	def get_dmt_account_id
		account = Account.find_dmt
		if !account
			return 0
		else
			return Account.find_dmt.id
		end
	end

	def get_dmt_balance
		account = Account.find_dmt
		if !account
			return 0.00
		else
			return account.balance
		end
	end
end
