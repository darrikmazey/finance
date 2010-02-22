class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
	has_many :invoices
	has_many :rates
	has_many :work_items

  has_many :project_users
  has_many :users, :through => :project_users

	def transactions
		self.invoices.map(&:transactions).flatten
	end

end
