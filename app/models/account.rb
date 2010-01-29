class Account < ActiveRecord::Base
  belongs_to :user
	has_many :credits, :class_name => 'Transaction', :foreign_key => 'credit_account_id'
	has_many :debits, :class_name => 'Transaction', :foreign_key => 'debit_account_id'

	PERIODS = { 1 => :yearly, 2 => :semi_annually, 4 => :quarterly, 6 => :bi_monthly, 12 => :monthly, 24 => :semi_monthly, 26 => :bi_weekly, 52 => :weekly }
	TYPES = [ :debit_account, :credit_account, :billing_account, :debt_account, :bank_account, :budget_account ]

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

	def self.all_credit
		Account.all.select { |a| a.is_credit_account? }
	end

	def self.all_debit
		Account.all.select { |a| a.is_debit_account? }
	end

	def self.net_annual_debit
		debit = 0
		Account.all_debit.each do |d|
			debit += d.net_annual
		end
		debit
	end

	def self.net_monthly_debit
		self.net_annual_debit / 12
	end

	def self.net_annual_credit
		credit = 0
		Account.all_credit.each do |d|
			credit += d.net_annual
		end
		credit
	end

	def self.net_monthly_credit
		self.net_annual_credit / 12
	end

	def self.net_annual
		self.net_annual_debit - self.net_annual_credit
	end

	def self.net_monthly
		self.net_annual / 12
	end

	def self.credit_balance
		sum = 0
		Account.all_credit.each do |c|
			sum += c.balance
		end
		sum
	end

	def self.debit_balance
		sum = 0
		Account.all_debit.each do |c|
			sum += c.balance
		end
		sum
	end

	def self.net_balance
		self.debit_balance - self.credit_balance
	end

	def net_annual
		self.amount * self.period
	end

	def net_monthly
		self.net_annual / 12
	end

	def flags
		f = ''

		if self.positive?
			f += 'positive_account '
		else
			f += 'negative_account '
		end

		if self.overdue?
			f += 'overdue_account '
		else
			f += 'current_account '
		end

		if self.is_credit_account?
			f += 'credit_account '
		else
			f += 'debit_account '
		end

		f
	end

	def transactions
		Transaction.find(:all, :conditions => ['credit_account_id = ? or debit_account_id = ?', self.id, self.id])
	end

	def recent_transactions(limit = 20)
		Transaction.find(:all, :conditions => ['credit_account_id = ? or debit_account_id = ?', self.id, self.id], :order => ['trans_date desc, id desc'], :limit => limit)
	end

	def current_period_end
		self.period_end
	end

	def current_period_start
		self.period_start
	end

	def last_period_end
		self.period_end(1)
	end

	def last_period_start
		self.period_start(1)
	end

	def period_end(p = 0)
		pe = self.next_due_date
		p.times do
			pe = pe - Account::Period[self.period].delta
		end
		pe
	end

	def period_start(p = 0)
		self.period_end(p + 1) + 1.day
	end

	def next_due_date
		ndd = self.due_date
		while ndd < DateTime.now
			ndd += Account::Period[self.period].delta
		end
		ndd
	end

	def overdue?
		(DateTime.now + 3.days) > self.next_due_date
	end

	def balance
		debits = Transaction.sum(:amount, :conditions => ['debit_account_id = ?', self.id])
		credits = Transaction.sum(:amount, :conditions => ['credit_account_id = ?', self.id])
		
		if self.is_debit_account?
			self.initial_balance + debits - credits
		elsif self.is_credit_account?
			self.initial_balance + credits - debits
		end
	end

	def balance_before(t)
		debits = Transaction.sum(:amount, :conditions => ['debit_account_id = ? and trans_date <= ? and not id = ?', self.id, t.trans_date, t.id])
		credits = Transaction.sum(:amount, :conditions => ['credit_account_id = ? and trans_date <= ? and not id = ?', self.id, t.trans_date, t.id])

		if self.is_debit_account?
			self.initial_balance + debits - credits
		elsif self.is_credit_account?
			self.initial_balance + credits - debits
		end
	end

	def balance_at(t)
		debits = DebitTransaction.sum(:amount, :conditions => ['account_id = ? and trans_date <= ?', self.id, t.trans_date])
		credits = CreditTransaction.sum(:amount, :conditions => ['account_id = ? and trans_date <= ?', self.id, t.trans_date])

		if self.is_debit_account?
			self.initial_balance + debits - credits
		elsif self.is_credit_account?
			self.initial_balance + credits - debits
		end
	end

	def positive?
		self.balance >= 0
	end

	def negative?
		!self.positive?
	end

	def respond_to?(id, include_private = false)
		id_str = id.to_s
		if id_str =~ /is_(.*_account)\?/
			account_type = $1
			if account_type.to_sym == :abstract_account
				return true
			elsif TYPES.include? account_type.to_sym
				return true
			end
		end
		super(id, include_private)
	end

	def method_missing(id, *args)
		id_str = id.to_s
		if id_str =~ /is_(.*_account)\?/
			account_type = $1
			if account_type.to_sym == :abstract_account
				if ["Account", "CreditAccount", "DebitAccount" ].include? self.class.name.camelize
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
		@@names = { 1 => 'yearly', 2 => 'semi-annually', 4 => 'quarterly', 6 => 'bi-monthly', 12 => 'monthly', 24 => 'semi-monthly', 26 => 'bi-weekly', 52 => 'weekly' }
		@@singular = { 1 => 'year', 2 => 'half', 4 => 'quarter', 6 => 'period', 12 => 'month', 24 => 'period', 26 => 'period', 52 => 'week' }
		@@plural = { 1 => 'years', 2 => 'halves', 4 => 'quarters', 6 => 'periods', 12 => 'months', 24 => 'periods', 26 => 'periods', 52 => 'weeks' }
		@@deltas = { 1 => 1.year, 2 => 26.weeks, 4 => 13.weeks, 6 => 2.months, 12 => 1.month, 24 => (1.month / 2), 26 => 2.weeks, 52 => 1.week }

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

		def delta
			@@deltas[@p]
		end

	end
end
