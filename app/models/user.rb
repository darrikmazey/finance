class User < ActiveRecord::Base
	has_many :accounts
	has_many :clients
	has_many :invoices
	has_many :projects

	validates_presence_of :hashed_password
	validates_presence_of :salt
	validates_presence_of :username
	validates_uniqueness_of :username

	attr_accessor :password_confirmation
	validates_confirmation_of :password

	def loose_client_accounts
		self.client_accounts.select { |a| a.client.nil? }
	end

	def client_accounts
		ClientAccount.find :all, :conditions => ['user_id = ?', self.id], :order => ['name asc']
	end

	def credit_accounts
		self.accounts.select { |a| a.is_credit_account? }
	end

	def debit_accounts
		self.accounts.select { |a| a.is_debit_account? }
	end

	def credit_balance_sans_client
		sum = 0
		self.credit_accounts.select { |c| !c.is_client_account? }.each do |c|
			sum += c.real_balance
		end
		sum
	end

	def credit_balance_sans_client_on_date(d)
		sum = 0
		self.credit_accounts.select { |c| !c.is_client_account? }.each do |c|
			sum += c.balance_on_date(d)
		end
		sum
	end

	def credit_balance
		sum = 0
		self.credit_accounts.each do |c|
			if c.root?
				sum += c.real_balance
			end
		end
		sum
	end

	def credit_balance_on_date(d)
		sum = 0
		self.credit_accounts.each do |c|
			sum += c.real_balance_on_date(d)
		end
		sum
	end

	def debit_balance
		sum = 0
		self.debit_accounts.each do |c|
			if c.root?
				sum += c.real_balance
			end
		end
		sum
	end

	def debit_balance_on_date(d)
		sum = 0
		self.debit_accounts.each do |c|
			if c.root?
				sum += c.real_balance_on_date(d)
			end
		end
		sum
	end

	def net_balance_sans_client
		self.debit_balance - self.credit_balance_sans_client
	end

	def net_balance_sans_client_on_date(d)
		self.debit_balance_on_date(d) - self.credit_balance_sans_client_on_date(d)
	end

	def net_balance
		self.debit_balance - self.credit_balance
	end

	def net_balance_on_date(d)
		self.debit_balance_on_date(d) - self.credit_balance_on_date(d)
	end

	def net_annual_debit
		debit = 0
		BankAccount.find(:all, :conditions => { :user_id => self.id }).each do |d|
			debit += d.net_annual
		end
		debit
	end

	def net_monthly_debit
		self.net_annual_debit / 12
	end

	def net_annual_credit
		credit = 0
		BudgetAccount.find(:all, :conditions => { :user_id => self.id }).each do |d|
			credit += d.net_annual
		end
		credit
	end

	def net_monthly_credit
		self.net_annual_credit / 12
	end

	def net_annual
		self.net_annual_debit - self.net_annual_credit
	end

	def net_monthly
		self.net_annual / 12
	end

	def password
		@password
	end

	def password=(p)
		@password=p
		return if p.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end

	def self.authenticate(name, pass)
		return nil if name.blank?
		return nil if pass.blank?
		d = self.find_by_username(name)
		if d
			expected_password = encrypted_password(pass, d.salt)
			if d.hashed_password != expected_password
				d = nil
			end
		end
		d
	end

	private

	def self.encrypted_password(p, s)
		plaintext = 'messerskandh' + p + 'wouldyoupleaseshutthehellup' + s
		Digest::SHA256.hexdigest(plaintext)
	end

	def create_new_salt
		self.salt = rand.to_s + self.object_id.to_s + rand.to_s
	end

end
