class Transaction < ActiveRecord::Base
  belongs_to :account

	def self.model_name
		name = 'transaction'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def credit?
		self.credit_amount > 0
	end

	def debit?
		self.debit_amount > 0
	end

	def amount=(a)
		0
	end

	def amount
		0
	end

	def transaction_type
		if self.credit?
			return 'credit'
		end
		if self.debit?
			return 'debit'
		end
		return 'error'
	end

	def flags
		f = ''

		if self.debit?
			f += 'debit_transaction '
		else
			f += 'credit_transaction '
		end
		
		f
	end

end
