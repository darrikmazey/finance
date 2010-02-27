class AccountGroup < ActiveRecord::Base
  validates_presence_of :name

  has_many :account_group_users
  has_many :users, :through => :account_group_users
  has_many :accounts
  has_many :clients, :through => :accounts

  def projects
    clients.collect { |client| client.projects }.flatten.uniq
  end
end
