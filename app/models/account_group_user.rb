class AccountGroupUser < ActiveRecord::Base
  validates_presence_of :user_id

  belongs_to :user
  belongs_to :account_group
end
