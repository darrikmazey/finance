class CreateWorkItems < ActiveRecord::Migration
  def self.up
    create_table :work_items do |t|
      t.references :user
      t.references :project
      t.references :rate
      t.references :invoice
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def self.down
    drop_table :work_items
  end
end
