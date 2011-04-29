class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
	has_many :invoices
	has_many :rates
	has_many :work_items
  has_many :expense_items

  has_many :project_users
  has_many :workers, :source => :user, :through => :project_users
  accepts_nested_attributes_for :project_users, :allow_destroy => true

	def transactions
		self.invoices.map(&:transactions).flatten
	end

  def account_group
    client.account.account_group rescue nil
  end

	def ytd
		self.invoices.select {|i| !i.paid_at.nil? && i.paid_at >= Date.new(Date.today.year, 1, 1) }.sum(&:total)
	end

	def last_12_months
		self.invoices.select { |i| !i.paid_at.nil? && i.paid_at >= 12.months.ago }.sum(&:total)
	end

	def last_calendar_year
		self.invoices.select { |i| !i.paid_at.nil? && i.paid_at >= Date.new(Date.today.year - 1, 1, 1) && i.paid_at < Date.new(Date.today.year, 1, 1) }.sum(&:total)
	end

	def ytd_last_year
		self.invoices.select { |i| !i.paid_at.nil? && i.paid_at >= Date.new(Date.today.year - 1, 1, 1) && i.paid_at < Date.new(Date.today.year - 1, Date.today.month, Date.today.day) }.sum(&:total)
	end

end
