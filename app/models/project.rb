class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
	has_many :invoices
	has_many :rates
	has_many :work_items

	def transactions
		self.invoices.map(&:transactions).flatten
	end

end
