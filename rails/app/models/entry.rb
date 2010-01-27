class Entry < ActiveRecord::Base
	belongs_to :accounts

	def redirect_account
		if self.from_account_id
			return self.from_account_id
		elsif self.to_account_id
			return self.to_account_id
		else
			return nil
		end
	end

	def to_account_name 
		begin
			@account_obj = Account.find self.to_account_id
		rescue ActiveRecord::RecordNotFound
			return nil
		end
		if @account_obj
			return @account_obj.type.to_s + " - " + @account_obj.name
		end
	end

	def from_account_name
		begin 
			@account_obj = Account.find self.from_account_id
		rescue ActiveRecord::RecordNotFound
			return "Invoice #" + self.invoice_id.to_s
		end
		if @account_obj
			return @account_obj.type.to_s + " - " + @account_obj.name
		end
	end

	# returns the amount based on the account_id argument
	# if the account is in the 'from' then the amount is shown negative
	def amount(account_id=0)
		amt = read_attribute(:amount)
		if account_id.to_s == self.from_account_id.to_s
			amt = amt * -1
		end
		return amt
	end

	def date	
		date = read_attribute(:date)
		if !date
			date = DateTime.now
			write_attribute(:date, date)
		end
		return date
	end

	def self.find_account(account_id)
		return Entry.find(:all,
			:conditions => [ "to_account_id = " + account_id.to_s +
				" or from_account_id = " + account_id.to_s ],
			:order => "date")
	end
end
