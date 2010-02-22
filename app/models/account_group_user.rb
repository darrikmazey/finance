class AccountGroupUser < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :account_group_id

  belongs_to :user
  belongs_to :account_group

  validates_associated :user
  validates_associated :account_group
end
