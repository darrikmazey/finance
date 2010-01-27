class Account < ActiveRecord::Base
	belongs_to :account_type
	has_many :entries

	# creates a new object of type 't' with the data from 'n'
	# and returns it
	def self.dup(old, type)
		new = Object.const_get(type).new
		new.account_name = old.account_name
		new.id = old.id
		new.account_type_id = old.account_type_id
		new.reference_id = old.reference_id
		new.created_at = old.created_at
		new.balance_date = old.balance_date
		new.balance = old.balance
		return new
	end

	def account_balance
		entries = Entry.find_account(self.id)
		sum = 0.00
		entries.each do |e|
			sum += e.amount(self.id)
		end
		return sum
	end

	def balance
		bal = self.account_balance
		write_attribute(:balance, bal)
		write_attribute(:balance_date, DateTime.now)
		self.save
		return bal
	end

	def reference_object
		if @reference_obj.nil?
			if self.reference_id
				begin
					@reference_obj = Object.const_get('Hours' + self.type.to_s).find self.reference_id
				rescue ActiveRecord::RecordNotFound
					return nil
				end
			end
		end
		@reference_obj
	end

	def name
		if !self.account_name.nil?
			self.account_name
		elsif self.type.to_s == "Client"
			self.hours_client.name
		elsif self.type.to_s == "Developer"
			self.hours_developer.name
		else
			'[unnamed ' + self.type.to_s.downcase + ' account]'
		end
	end

	def name=(n)
		if !self.reference_id.nil?
			if self.type.to_s == "Client"
				hc = self.hours_client
				hc.name = n
			elsif self.type.to_s == "Developer"
				hd = self.hours_developer
				hd.name = n
			else 
				self.account_name = n
			end
		else 
			self.account_name = n
		end
	end

	def save
		if super
			if !self.reference_id.nil?
				if self.type.to_s == 'Client'
					hc = self.hours_client
					hc.save
				elsif self.type.to_s == 'Developer'
					hd = self.hours_developer
					hd.save
				end
			else
				true
			end
		end
	end

	def type_and_name
		s = self.type.to_s
		s += ' - ' + self.name
	end

	def self.find_dmt
		begin
			account = Account.find :first, :conditions => { :type => nil, :account_name => 'DMT Programming' }
		rescue ActiveRecord::AccountNotFound
			# if we can't find it by name then pull the first 'account'
			account = Account.find :first, :conditions => { :type => nil }
		end
	end
end
