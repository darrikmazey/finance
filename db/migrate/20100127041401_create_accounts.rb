class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :description
      t.float :initial_balance
      t.string :type
      t.references :user
      t.datetime :due_date
      t.integer :period

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
