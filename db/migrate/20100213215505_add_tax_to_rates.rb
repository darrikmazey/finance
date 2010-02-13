class AddTaxToRates < ActiveRecord::Migration
  def self.up
		add_column :rates, :taxeable, :boolean, :default => false
		add_column :rates, :tax, :float, :default => 0.0
  end

  def self.down
		remove_column :rates, :taxeable
		remove_column :rates, :tax
  end
end
