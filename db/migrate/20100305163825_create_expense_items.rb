class CreateExpenseItems < ActiveRecord::Migration
  def self.up
    create_table :expense_items do |t|
      t.references :project
      t.references :invoice
      t.references :user
      t.string :description
      t.float :rate
      t.float :hours
      t.timestamps
    end
  end

  def self.down
    drop_table :expense_items
  end
end
