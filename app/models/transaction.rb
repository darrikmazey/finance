class Transaction < ActiveRecord::Base
  belongs_to :debit_account, :class_name => 'Account'
	belongs_to :credit_account, :class_name => 'Account'
	belongs_to :invoice

	def self.model_name
		name = 'transaction'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def credit_amount
		self.credit_account ? amount : 0
	end

	def debit_amount
		self.debit_account ? amount : 0
	end

	def credit_amount_flags
		f = ''
		if self.credit_amount > 0
			f += 'non_zero '
		else
			f += 'zero '
		end
		f
	end

	def debit_amount_flags
		f = ''
		if self.debit_amount > 0
			f += 'non_zero '
		else
			f += 'zero '
		end
		f
	end

	def flags
		f = ''

		if self.credit_account and self.debit_account
			if (self.credit_account.is_credit_account? and self.debit_account.is_credit_account?)
				f += 'cred_tran_transaction'
				return f
			elsif (self.credit_account.is_debit_account? and self.debit_account.is_debit_account?)
				f += 'deb_tran_transaction'
				return f
			end
		end
		if self.credit_account
			if self.credit_account.is_credit_account?
				f += 'incr_transaction '
			else
				f += 'decr_transaction '
			end
		elsif self.debit_account
			if self.debit_account.is_debit_account?
				f += 'incr_transaction '
			else
				f += 'decr_transaction '
			end
		end
		
		f
	end

end
