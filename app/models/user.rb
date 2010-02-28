require 'digest/sha1'

class User < ActiveRecord::Base

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles

	attr_accessor :password_confirmation
  attr_accessor :old_password

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
   
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

	validates_presence_of :salt
	validates_confirmation_of :password

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :old_password, :template, :account_group_id

  has_many :clients
	has_many :invoices
	has_many :work_items
	has_many :rates, :through => :projects
	has_many :transactions, :through => :invoices

  # account_groups user is directly associated with (user is admin)
  has_many :account_group_users
  #has_many :admin_account_groups, :source => 'account_group', :through => :account_group_users, :uniq => true

  # default account_group
  belongs_to :account_group

  # these are all of the projects user is a worker of
  has_many :project_users
	has_many :worker_projects, :source => 'project', :through => :project_users

  # all of this users's projects. worker and current account_group
  def all_projects
    pro = worker_projects.to_a
    (pro << @user_options.account_group.projects).uniq if @user_options
    return pro
  end

  def admin_account_groups
    account_group_users.collect { |agu| agu.account_group }.flatten.uniq
  end

  # admin account groups and the account groups for worker projects
  def account_groups
    ags = admin_account_groups.to_a
    worker_projects.each { |project|
      ags << project.account_group
    }
    return ags.compact.uniq
  end 

  # all of the projects for an account_group
  def projects_for_account_group(_account_group = nil)
    return [] unless _account_group

    # return all of the projects for the account group
    # if the user is an admin for that account group
    return _account_group.projects if admin_account_groups.include?(_account_group)
     
    # return all of the projects that are in the account group
    # and the user is a worker for
    return _account_group.projects.collect { |project| 
      worker_projects.include?(project) ? project : nil
    }.compact.uniq
  end

  # all of the clients for an account_group
  def clients_for_account_group(_account_group = nil)
    return [] unless _account_group

    # all clients if admin
    return _account_group.clients if admin_account_groups.include?(_account_group)

    # only clients for projects user is worker of
    return _account_group.projects.collect { |project|
      worker_projects.include?(project) ? project.client : nil
    }.flatten.compact.uniq
  end

  def user_options
    ag = self.account_group || self.account_groups.first || nil
    ag = nil unless ag
    ag = ag.id if ag
    ag = self.account_groups.first unless self.account_groups.include?(ag)
    return { 
        "account_group_id" => ag.id,
        "user_id" => self.id,
        "template" => self.template
      }
  end

  def accounts
    ag = account_group
    ag = @user_options.account_group if @user_options
    ag = account_groups.first unless self.account_groups.include?(ag) 
    return ag.accounts
  end

	def last_project
		wi = self.last_work_item
		if wi
			wi.project
		else
			nil
		end
	end

	def last_rate
		wi = self.last_work_item
		if wi
			wi.rate
		else
			nil
		end
	end

	def city_state_zip
		company_city + ', ' + company_state + ' ' + company_zipcode
	end

	def last_work_item
		WorkItem.find :first, :conditions => { :user_id => self.id }, :order => 'start_time DESC'
	end

	def asset_accounts
		accounts_of_type(AssetAccount)
	end

	def liability_accounts
		accounts_of_type(LiabilityAccount)
	end

	def capital_accounts
		accounts_of_type(CapitalAccount)
	end

	def accounts_of_type(t)
		accounts.select { |a| a.is_a? t }
	end
		
	def balance
		asset_balance - liability_balance
	end

	def asset_balance
		asset_accounts.inject(0) { |s,a| s += a.balance }
	end

	def liability_balance
		liability_accounts.inject(0) { |s,a| s += a.balance }
	end

	def capital_balance
		capital_accounts.inject(0) { |s,a| s += a.balance }
	end

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected

    def make_activation_code
      self.deleted_at = nil
      self.activation_code = self.class.make_token
    end

end
