class AddDefaultAccountGroupToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :account_group_id, :integer
  end

  def self.down
    remove_column :users, :account_group_id
  end
end
