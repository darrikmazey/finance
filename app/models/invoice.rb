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

	def total
		work_items.inject(0) { |s,v| s += v.total }
	end

	def hours
		work_items.inject(0) { |s,v| s += v.hours }
	end
end
