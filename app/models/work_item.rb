class WorkItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :rate
  belongs_to :invoice
	has_many :comments

	named_scope :open, { :conditions => { :end_time => nil } }
	named_scope :loose, { :conditions => { :invoice_id => nil } }
	named_scope :ascending_creation, { :order => 'start_time asc, id asc' }

  def invoice_start_time
    start_time
  end

	def align_start_time
		if self.start_time.nil?
			return nil
		end
		fstime = self.start_time.to_f / (15 * 60)
		istime = fstime.to_i
		if (fstime != istime)
			d = fstime - istime
			if d >= 0.5
				a = 15 - (self.start_time.min % 15)
				nstime = self.start_time + a.minutes
				nstime = Time.zone.local(nstime.year, nstime.month, nstime.day, nstime.hour, nstime.min, 0)
				self.start_time = nstime
			else
				s = self.start_time.min % 15
				nstime = self.start_time - s.minutes
				nstime = Time.zone.local(nstime.year, nstime.month, nstime.day, nstime.hour, nstime.min, 0)
				self.start_time = nstime
			end
		end
	end

	def align_end_time
		if self.end_time.nil?
			return nil
		end
		fstime = self.end_time.to_f / (15 * 60)
		istime = fstime.to_i
		if (fstime != istime)
			d = fstime - istime
			if d >= 0.5
				a = 15 - (self.end_time.min % 15)
				nstime = self.end_time + a.minutes
				nstime = Time.zone.local(nstime.year, nstime.month, nstime.day, nstime.hour, nstime.min, 0)
				self.end_time = nstime
			else
				s = self.end_time.min % 15
				nstime = self.end_time - s.minutes
				nstime = Time.zone.local(nstime.year, nstime.month, nstime.day, nstime.hour, nstime.min, 0)
				self.end_time = nstime
			end
		end
		if self.end_time == self.start_time
			self.end_time = self.end_time + 15.minutes
		end
	end

	def subtotal
    if !project.nil?
      self.hours * project.base_rate * rate.modifier
    else
      return 0
    end
	end

	def tax
		if rate.taxeable?
			subtotal * rate.tax
		else
			0
		end
	end

	def total
		subtotal + tax
	end

	def hours
		if self.end_time.nil?
			0
		else
			tmphours = ((self.end_time - self.start_time) / 3600) * 100 + 24
			inthours = tmphours.to_i / 25
			tmphours = inthours.to_f * 0.25
		end
	end

	def open
		self.end_time = nil
	end

	def close
		self.end_time = DateTime.now
		self.align_end_time
	end

	def split!
		nwi = WorkItem.new
		nwi.start_time = self.start_time + (self.end_time - self.start_time)/2
		nwi.end_time = self.end_time
		self.end_time = nwi.start_time
		nwi.user = self.user
		nwi.project = self.project
		nwi.rate = self.rate
		nwi.invoice = self.invoice
		nwi.align_start_time
		self.align_end_time
		nwi.save
		self.save
	end

	def closed?
		!self.end_time.nil?
	end

  def total_rate
    rate.modifier * project.base_rate
  end
  
end
