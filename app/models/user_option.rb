class UserOption < TablelessModel
  column :account_group_id, :id
  column :user_id, :id

  belongs_to :user
  belongs_to :account_group
end
