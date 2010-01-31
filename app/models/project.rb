class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
	has_many :invoices

	def transactions
		self.invoices.map(&:transactions).flatten
	end

end
