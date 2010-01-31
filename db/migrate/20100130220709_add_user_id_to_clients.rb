class AddUserIdToClients < ActiveRecord::Migration
  def self.up
		add_column :clients, :user_id, :integer
  end

  def self.down
		remove_column :clients, :user_id
  end
end
