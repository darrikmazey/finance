class Period
	@@NAMES = {
		1 => 'annually',
		2 => 'semi-annually',
		4 => 'quarterly',
		6 => 'bi-monthly',
		12 => 'monthly',
		24 => 'semi-monthly',
		26 => 'bi-weekly',
		52 => 'weekly',
		104 => 'semi-weekly',
		365 => 'daily'
	}

	@@DELTAS = {
		1 => 1.year,
		2 => 6.months,
		4 => 3.months,
		6 => 2.months,
		12 => 1.month,
		24 => (1.month / 2),
		26 => 2.weeks,
		52 => 1.week,
		104 => (1.week / 2),
		365 => 1.day
	}

	@@SINGLE = {
		1 => 'year',
		2 => 'half',
		4 => 'quarter',
		6 => 'period',
		12 => 'month',
		24 => 'period',
		26 => 'period',
		52 => 'week',
		104 => 'period',
		365 => 'day'
	}

	@@instances = Hash.new
	
	def self.[](n)
		if !@@instances[n]
			@@instances[n] = Period.new(n)
		end
		@@instances[n]
	end

	def self.all
		@@NAMES.keys.sort.reverse.map { |v| self[v] }
	end

	def self.convert(amount, from, to)
		amount * from / to
	end

	def initialize(n)
		@period = n
	end

	def value
		@period
	end

	def name
		@@NAMES[@period]
	end

	def singular
		@@SINGLE[@period]
	end

	def plural
		@@SINGLE[@period].pluralize
	end

	def delta
		@@DELTAS[@period]
	end

	def start_date(n = 0)
		d = start_of_year
		while d < DateTime.now
			d += delta
		end
		if n > 0
			n.times do
				d = d + delta
			end
		elsif n < 0
			n.abs.times do
				d = d - delta
			end
		end
		d - delta
	end

	def end_date(n = 0)
		start_date(n) + delta - 1.second
	end

  #private

	def start_of_year
		(DateTime.now - 1.year).end_of_year + 1.second
	end
end
