class Transaction < ActiveRecord::Base
  belongs_to :debit_account, :class_name => 'Account'
	belongs_to :credit_account, :class_name => 'Account'
	belongs_to :invoice

	named_scope :before_date, lambda { |d| { :conditions => ['trans_date < ?', d.utc] } }
	named_scope :for_account, lambda { |a| { :conditions => ['credit_account_id = ? or debit_account_id = ?', a.id, a.id] } }
	named_scope :credits_for_account, lambda { |a| { :conditions => ['credit_account_id = ?', a.id ] } }
	named_scope :debits_for_account, lambda { |a| { :conditions => ['debit_account_id = ?', a.id ] } }
	named_scope :recent, lambda { { :conditions => [ 'trans_date >= ?', (2.weeks.ago)] } }

	def self.all_for_user(u)
		u.accounts.collect { |a| a.transactions }.flatten.uniq.sort { |a,b| a.trans_date <=> b.trans_date }
	end

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
		[]
	end

	def debit_amount_flags
		[]
	end

	def flags
		[]
	end

end
