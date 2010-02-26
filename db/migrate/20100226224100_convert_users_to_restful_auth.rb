class ConvertUsersToRestfulAuth < ActiveRecord::Migration
  def self.up
    # make the first user admin
    admin = User.first
    counter = 1
    puts "NOTE: Updating all user password to 'password', please log in each user account and fix password" unless User.all.empty?
    User.all.each { |user|
      if user == admin
        user.admin = true
      end
      user.password = 'password'
      user.password_confirmation = 'password'
      user.email = "email#{counter.to_s}@email.com"
      user.salt = User.make_token
      user.state = "active"
      user.activated_at = Time.now
      if !user.save
        puts "Error saving user: [#{user.errors.full_messages}]"
      end
      counter += 1
    }
  end

  def self.down
  end
end
