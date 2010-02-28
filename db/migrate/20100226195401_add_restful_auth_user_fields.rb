class AddRestfulAuthUserFields < ActiveRecord::Migration
  def self.up
    rename_column :users, :username, :login
    rename_column :users, :hashed_password, :crypted_password
    add_column :users, :name, :string, :limit => 100, :default => '', :null => true
    add_column :users, :email, :string, :limit => 100
    add_column :users, :remember_token, :string, :limit => 40
    add_column :users, :remember_token_expires_at, :datetime
    add_column :users, :activation_code, :string, :limit => 40
    add_column :users, :activated_at, :datetime
    add_column :users, :state, :string, :null => :no, :default => 'passive'
    add_column :users, :deleted_at, :datetime
  end

  def self.down
    rename_column :users, :login, :username
    rename_column :users, :crypted_password, :hashed_password
    remove_column :users, :name
    remove_column :users, :email
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    remove_column :users, :activation_code
    remove_column :users, :activated_at
    remove_column :users, :state
    remove_column :users, :deleted_at
  end
end
