class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :hashed_password
      t.string :salt
      t.datetime :last_login

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
