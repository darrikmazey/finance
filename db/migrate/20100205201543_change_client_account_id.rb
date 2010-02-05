class ChangeClientAccountId < ActiveRecord::Migration
  def self.up
		rename_column :clients, :client_account_id, :account_id
  end

  def self.down
		rename_column :clients, :account_id, :client_account_id
  end
end
