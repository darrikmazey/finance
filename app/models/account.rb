class Account < ActiveRecord::Base
  belongs_to :user

	PERIODS = { 1 => :yearly, 12 => :monthly }
	TYPES = [ :billing_account, :debt_account, :bank_account ]

	def self.hidden_fields
		[]
	end

	def self.model_name
		name = 'account'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def balance
		self.initial_balance
	end

	def positive?
		self.balance >= 0
	end

	def negative?
		!self.positive?
	end

	def method_missing(id, *args)
		id_str = id.to_s
		if id_str =~ /is_(.*_account)\?/
			account_type = $1
			if account_type.to_sym == :abstract_account
				if self.class.name.camelize == "Account"
					return true
				else
					return false
				end
			elsif TYPES.include? account_type.to_sym
				if account_type.camelize == self.class.name
					return true
				else
					return false
				end
			else
				super(id, *args)
			end
		end
		super(id, *args)
	end

	def show_field?(field)
		if self.class.hidden_fields.include? field
			false
		else
			true
		end
	end

	def protected_field(field, disp, alt = nil)
		if self.show_field? field
			disp
		else
			alt
		end
	end

## supporting classes

	class AccountType
		
		def self.all
			arr = Array.new
			Account::TYPES.each do |t|
				arr << Account::AccountType[t]
			end
			arr
		end

		def self.[](t)
			if Account::TYPES.include? t
				Account::AccountType.new(t)
			else
				nil
			end
		end

		def initialize(t)
			@t = t
		end

		def to_s
			@t.to_s.titleize
		end

		def class_name
			@t.to_s.camelize
		end
	end

	class Period
		@@instances = Hash.new
		@@names = { 1 => 'yearly', 12 => 'monthly' }
		@@singular = { 1 => 'year', 12 => 'month' }
		@@plural = { 1 => 'years', 12 => 'months' }

		def self.all
			Account::PERIODS.each_key do |k|
				Account::Period[k]
			end
			@@instances.values.to_a
		end

		def self.[](n)
			if @@instances[n]
				return @@instances[n]
			end
			@@instances[n] = Account::Period.new(n)
		end

		def initialize(n)
			@p = n
		end

		def period
			@p
		end

		def name
			@@names[@p]
		end

		def singular
			@@singular[@p]
		end

		def plural
			@@plural[@p]
		end
	end
end