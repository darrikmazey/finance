class AddParentIdToAccounts < ActiveRecord::Migration
  def self.up
		add_column :accounts, :parent_id, :integer
  end

  def self.down
		remove_column :accounts, :parent_id
  end
end
