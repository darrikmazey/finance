class Invoice < ActiveRecord::Base
  belongs_to :user
	has_many :transactions
	belongs_to :project
	has_one :client, :through => :project
	has_many :work_items

	def rev_sorted_transactions
		self.transactions.sort { |a, b| b.created_at <=> a.created_at }
	end
end
