class AddTemplateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :template, :string
  end

  def self.down
    remove_column :users, :template
  end
end
