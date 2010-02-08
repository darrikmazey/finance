class WorkItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :rate
  belongs_to :invoice

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

end
