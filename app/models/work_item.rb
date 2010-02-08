class WorkItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :rate
  belongs_to :invoice

	named_scope :open, { :conditions => { :end_time => nil } }
	named_scope :loose, { :conditions => { :invoice_id => nil } }

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
		self.hours * project.base_rate * rate.modifier
	end

	def total
		subtotal
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

	def closed?
		!self.end_time.nil?
	end
end
