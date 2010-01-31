class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.string :name
      t.references :project
      t.float :modifier

      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end
