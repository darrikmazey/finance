class HoursDeveloper < HoursRecord
	has_one :preferences
	has_many :work_items
	has_and_belongs_to_many :developer_groups

	validates_presence_of :hashed_password
	validates_presence_of :salt
	validates_presence_of :name

	attr_accessor :confirm_password
	validates_confirmation_of :password

	def self.table_name
		"developers"
	end

	def password
		@password
	end

	def password=(pwd)
		@password = pwd
		return if pwd.blank?
		create_new_salt
		self.hashed_password = Developer.encrypted_password(self.password, self.salt)
	end

	def self.authenticate(name, pass)
		return nil if name.blank?
		return nil if pass.blank?
		d = self.find_by_name(name)
		if d
			expected_password = encrypted_password(pass, d.salt)
			if d.hashed_password != expected_password
				d = nil
			end
		end
		d
	end

	def last_work_item
		WorkItem.find :first, :conditions => { :developer_id => self.id }, :order => 'start_time DESC'
	end

	def last_project
		wi = self.last_work_item
		if wi
			wi.project
		else
			nil
		end
	end

	def recent_work_items
		#WorkItem.find(:all, :conditions => { :developer_id => self.id }, :limit => 20, :order => :start_time)
		WorkItem.find(:all, :conditions => { :developer_id => self.id }, :order => :start_time)
	end

	def recent_unbilled_work_items
		wis = self.recent_work_items
		ubwis = []
		wis.each do |wi|
			if !wi.billed?
				ubwis << wi
			end
		end
		ubwis
	end

	def open_work_items
		WorkItem.find(:all, :conditions => { :developer_id => self.id, :end_time => nil }, :order => :start_time)
	end

	private

	def self.encrypted_password(password, salt)
		plaintext = password + 'yourmother' + salt
		Digest::SHA256.hexdigest(plaintext)
	end

	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end

end
