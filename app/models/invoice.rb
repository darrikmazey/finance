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
	end

	def unbill
		self.billed_at = nil
	end

	def total
		work_items.inject(0) { |s,v| s += v.total }
	end

	def hours
		work_items.inject(0) { |s,v| s += v.hours }
	end
end
