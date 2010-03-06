class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
	has_many :invoices
	has_many :rates
	has_many :work_items
  has_many :expense_items

  has_many :project_users
  has_many :workers, :source => :user, :through => :project_users
  accepts_nested_attributes_for :project_users, :allow_destroy => true

	def transactions
		self.invoices.map(&:transactions).flatten
	end

  def account_group
    client.account.account_group rescue nil
  end
end
