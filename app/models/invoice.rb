class Invoice < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
	has_many :transactions

	def rev_sorted_transactions
		self.transactions.sort { |a, b| b.created_at <=> a.created_at }
	end
end
