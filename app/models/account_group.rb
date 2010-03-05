class AccountGroup < ActiveRecord::Base
  validates_presence_of :name

  has_many :account_group_users
  has_many :users, :through => :account_group_users
  has_many :accounts
  has_many :clients, :through => :accounts

  accepts_nested_attributes_for :account_group_users, :allow_destroy => true

  def projects
    clients.collect { |client| client.projects }.flatten.uniq
  end

  def invoices
    projects.collect { |project| project.invoices }.flatten.uniq
  end
end
