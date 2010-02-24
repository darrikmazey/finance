class AccountGroup < ActiveRecord::Base
  validates_presence_of :name

  has_many :account_group_users
  has_many :users, :through => :account_group_users

  has_many :accounts
end
