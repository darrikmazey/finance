class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => 'Account', :foreign_key => 'parent_id'
	has_many :children, :class_name => 'Account', :foreign_key => 'parent_id'

	def self.model_name
		name = 'account'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def div_classes
		f = ['account']
		if positive?
			f << 'positive'
		else
			f << 'negative'
		end
		f
	end

	def balance
		initial_balance
	end

	def asset?
		false
	end

	def liability?
		false
	end

	def capital?
		false
	end

	def positive?
		balance >= 0
	end

	def negative?
		!positive?
	end
end
