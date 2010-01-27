class User < ActiveRecord::Base
	has_many :accounts

	validates_presence_of :hashed_password
	validates_presence_of :salt
	validates_presence_of :username
	validates_uniqueness_of :username

	attr_accessor :password_confirmation
	validates_confirmation_of :password

	def password
		@password
	end

	def password=(p)
		@password=p
		return if p.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end

	def self.authenticate(name, pass)
		return nil if name.blank?
		return nil if pass.blank?
		d = self.find_by_username(name)
		if d
			expected_password = encrypted_password(pass, d.salt)
			if d.hashed_password != expected_password
				d = nil
			end
		end
		d
	end

	private

	def self.encrypted_password(p, s)
		plaintext = 'messerskandh' + p + 'wouldyoupleaseshutthehellup' + s
		Digest::SHA256.hexdigest(plaintext)
	end

	def create_new_salt
		self.salt = rand.to_s + self.object_id.to_s + rand.to_s
	end

end
