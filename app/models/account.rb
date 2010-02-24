class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => 'Account', :foreign_key => 'parent_id'
	has_many :children, :class_name => 'Account', :foreign_key => 'parent_id'

	named_scope :root, { :conditions => { :parent_id => nil } }
	named_scope :of_type, lambda { |t| { :conditions => { :type => (t.to_s + '_account').camelize } } }

  belongs_to :account_group

	def self.model_name
		name = 'account'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def after_initialize
		@increasing = :none
	end

	def increasing
		@increasing
	end

	def div_classes
		f = ['account']
		if positive?
			f << 'positive'
		else
			f << 'negative'
		end
		if root?
			f << 'root'
		end
		if credit_increasing?
			f << 'credit_increasing'
		end
		if debit_increasing?
			f << 'debit_increasing'
		end
		f
	end

	def root?
		parent == nil
	end
	
	def transactions
		Transaction.for_account(self)
	end

	def recent_transactions
		transactions.recent
	end

	def total_amount
		if children.size > 0
			return amount + child_amount
		else
			return amount
		end
	end

	def credits
		Transaction.credits_for_account(self)
	end

	def credit_sum
		credits.sum(:amount)
	end

	def debits
		Transaction.debits_for_account(self)
	end

	def debit_sum
		debits.sum(:amount)
	end

	def real_balance
		balance + child_balance
	end

	def real_balance_div_flags
		f = Array.new
		if real_balance >= 0
			f << 'positive'
		else
			f << 'negative'
		end
		f
	end

	def unallocated_balance
		balance
	end

	def allocated_balance
		child_balance
	end

	def child_amount
    if self.period
      if credit_increasing?
        return children.inject(0) { |s, v| s += Period.convert(v.credit_amount, v.period, self.period) }
      end
      if debit_increasing?
        return children.inject(0) { |s, v| s += Period.convert(v.debit_amount, v.period, self.period) }
      end
    end
		0
	end

	def child_balance
		if credit_increasing?
			return children.inject(0) { |s, v| s += v.credit_balance }
		end
		if debit_increasing?
			return children.inject(0) { |s, v| s += v.debit_balance }
		end
		0
	end

	def balance
		if credit_increasing?
			return initial_balance + credit_sum - debit_sum
		end
		if debit_increasing?
			return initial_balance - credit_sum + debit_sum
		end
		0
	end

	def credit_amount
		if credit_increasing?
			return amount
		end
		if debit_increasing?
			return -1 * amount
		end
		0
	end

	def debit_amount
		if credit_increasing?
			return -1 * amount
		end
		if debit_increasing?
			return amount
		end
		0
	end

	def credit_balance
		if credit_increasing?
			return balance
		end
		if debit_increasing?
			return -1 * balance
		end
		0
	end

	def debit_balance
		if credit_increasing?
			return -1 * balance
		end
		if debit_increasing?
			return balance
		end
		0
	end

	def asset?
		false
	end

	def liability?
		false
	end

	def capital?
		false
	end

	def positive?
		real_balance >= 0
	end

	def negative?
		!positive?
	end

	def credit_sum
		Transaction.sum(:amount, :conditions => ['credit_account_id = ?', id])
	end

	def debit_sum
		Transaction.sum(:amount, :conditions => ['debit_account_id = ?', id])
	end

	def credit_increasing?
		@increasing == :credit
	end

	def debit_increasing?
		@increasing == :debit
	end

	def self.all_superclasses
		c = Array.new
		c << self.name
		o = self.superclass
		while o != ActiveRecord::Base
			c << o.name
			o = o.superclass
		end
		c
	end

	def self.types
		Type.all
	end

	class Type
		@@instances = Hash.new
		@@types = [ :bank, :budget, :equity, :expense, :revenue, :accounts_receivable, :accounts_payable, :asset, :liability, :capital ]

		def self.[](t)
			if !@@instances[t]
				@@instances[t] = Type.new(t)
			end
			@@instances[t]
		end

		def initialize(t)
		  @t = t
		end

		def class_name
			(@t.to_s + '_account').camelize
		end

		def display_name
			(@t.to_s + '_account').titleize
		end

		def self.all
			@@types.map {|t| Type.new(t) }
		end
	end
end

