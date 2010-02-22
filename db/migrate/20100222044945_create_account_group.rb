class CreateAccountGroup < ActiveRecord::Migration
  def self.up
    create_table :account_groups do |t|
      t.string :name
      t.string :description
    end

    create_table :account_group_users do |t|
      t.references :user
      t.references :account_group
    end

    create_table :project_users do |t|
      t.references :user
      t.references :project
    end
    
    add_column :accounts, :account_group_id, :integer
  end

  def self.down
    drop_table :account_groups
    drop_table :account_group_users
    drop_table :project_users
    remove_column :accounts, :account_group_id
  end
end
