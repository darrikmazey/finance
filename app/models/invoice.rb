class Invoice < ActiveRecord::Base
  belongs_to :user
	has_many :transactions
	belongs_to :project
	has_one :client, :through => :project
	has_many :work_items

	def rev_sorted_transactions
		self.transactions.sort { |a, b| b.created_at <=> a.created_at }
	end

	def bill
		self.billed_at = DateTime.now
		ar = user.accounts.of_type(:accounts_receivable).first
		ca = client.account
		if ar and ca
			t = Transaction.new
			t.trans_date = DateTime.now
			t.description = "Invoice #{identifier}"
			t.amount = total
			t.credit_account = ca
			t.debit_account = ar
			t.invoice = self
			t.save
		end
	end

	def unbill
		self.billed_at = nil
		ar = user.accounts.of_type(:accounts_receivable).first
		ca = client.account
		if ar and ca
			t = user.transactions.find(:first, :conditions => { :credit_account_id => ca, :debit_account_id => ar, :invoice_id => self } ) rescue nil
			if !t.nil?
				t.destroy
			end
		end
	end

	def paid
		self.paid_at = DateTime.now
		ar = user.accounts.of_type(:accounts_receivable).first
		ba = user.accounts.of_type(:bank).first
		if ar and ba
			t = Transaction.new
			t.trans_date = DateTime.now
			t.description = "Payment : Invoice #{identifier}"
			t.amount = total
			t.credit_account = ar
			t.debit_account = ba
			t.invoice = self
			t.save
		end
	end

	def unpaid
		self.paid_at = nil
		ar = user.accounts.of_type(:accounts_receivable).first
		ba = user.accounts.of_type(:bank).first
		if ar and ba
			t = user.transactions.find(:first, :conditions => { :credit_account_id => ar, :debit_account_id => ba, :invoice_id => self } ) rescue nil
			if !t.nil?
				t.destroy
			end
		end
	end

	def scoop_loose_work_items
		if project
			wis = project.work_items.loose
			wis.each do |wi|
				wi.invoice = self
				wi.save
			end
		end
	end

	def total
		work_items.inject(0) { |s,v| s += v.total }
	end

	def hours
		work_items.inject(0) { |s,v| s += v.hours }
	end
end
