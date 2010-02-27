class AccountGroup < ActiveRecord::Base
  validates_presence_of :name

  has_many :account_group_users
  has_many :users, :through => :account_group_users

  has_many :accounts

  def clients
    accounts.collect { |account| account.clients }.flatten.uniq
  end

  def client_accounts
    clients.collect { |client| client.account }.flatten.uniq
  end
end
