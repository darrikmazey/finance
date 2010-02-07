class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => 'Account', :foreign_key => 'parent_id'
	has_many :children, :class_name => 'Account', :foreign_key => 'parent_id'

	def self.model_name
		name = 'account'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def div_classes
		f = ['account']
		if positive?
			f << 'positive'
		else
			f << 'negative'
		end
		f
	end
	
	def transactions
		Transaction.for_account(self)
	end

	def recent_transactions
		transactions.recent
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

	def balance
		initial_balance
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
		balance >= 0
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

	def self.all_superclasses
		c = Array.new
		c << self.name
		o = self.superclass
		while o != ActiveRecord::Base
			puts o
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
		@@types = [ :bank, :budget, :asset, :liability, :capital ]

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

