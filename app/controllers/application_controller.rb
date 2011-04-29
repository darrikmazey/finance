# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'finance_classes'

class ApplicationController < ActionController::Base

  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
	
  before_filter :check_users_exist
  before_filter :check_account_groups_exist
	before_filter :load_user
	before_filter :get_version
  before_filter :load_menu

	private

  def check_users_exist
    if User.count == 0
      if controller_name != 'users' && (action_name == 'new' || action_name == 'edit')
        redirect_to new_user_path
      end
    end
  end

  def check_account_groups_exist
    if User.count != 0
      if AccountGroup.count == 0
        if controller_name != 'account_groups' && (action_name != 'new' && action_name != 'edit')
          redirect_to new_account_group_path
        end
      end
    end
  end

  def admin_required
    @current_user.admin? || render(:partial => '/sessions/admin_required', :layout => true)
  end
    
  def self_or_admin_required
    @current_user == @user || admin_required
  end

	def load_user
    @current_user = current_user
    if @current_user && (controller_name != "sessions" || action_name != "destroy")
      # create a hash of options, start with the defaults, merge in session and then merge in params
      h = @current_user.user_options
      h.merge!(session[:user_option]) if session[:user_option]

      # stringify the params user options
      p = {}
      params[:user_option].each { |k, v| p[k.to_s] = v } if params[:user_option]
      h.merge!(p) if p
      @user_options = UserOption.new(h)

      # save this in the session
      save_user_options
  
      if !@current_user.admin?
        render :partial => 'account_groups/no_account_groups', :layout => true unless @user_options.account_group
      end
      redirect_to :back if p["account_group_id"]
    end
	end

	def get_version
		@VERSION = %x[cd #{RAILS_ROOT} && cat VERSION]
		if @VERSION.nil?
			@VERSION = 'none'
		end
		@VERSION.chomp!
		if RAILS_ENV == "development"
			@VERSION += ' [dev]'
		end
		if RAILS_ENV == "test"
			@VERSION += ' [test]'
		end
	end

  def admin_account_group_required(path = "/#{controller_name}")
    if !@current_user.admin? || !@user_options.admin_account_group?
      flash[:error] = "You are only a worker, you do not have permission to do that!"
      redirect_to path
    end
  end

  def admin_account_group_required_redirect_root
    if !@current_user.admin? || !@user_options.admin_account_group?
      flash[:error] = "You are only a worker, you do not have permission to do that!"
      redirect_to '/'
    end
  end

  def save_user_options
      session[:user_option] = @user_options.attributes
  end

  class MenuLink
    attr_accessor :name, :url, :children, :new_path

    def initialize(name, url, children, new_path)
      self.name = name
      self.url = url
      self.children = children
      self.new_path = new_path
    end
  end

  def link_to(name, url = nil, options = {})
    MenuLink.new(name, url, options.delete(:children), options.delete(:new_path))
  end

  def load_menu
    @menu = []

		puts @current_user.inspect
		if !@current_user.nil?
			if @user_options.try(:admin_account_group?)
				@menu << link_to('finance', root_path, { :children => [
					link_to('account groups', account_groups_url, { :new_path => new_account_group_url }),
					link_to('accounts', accounts_url, { :new_path => new_account_url }),
					link_to('transaction', transactions_url, { :new_path => new_transaction_url })
				]})
				@menu << link_to('projects', projects_url, { :children => [
					link_to('clients', clients_url, { :new_path => new_client_url }),
					link_to('invoices', invoices_url, { :new_path => new_invoice_url }),
					link_to('projects', projects_url, { :new_path => new_project_url }),
					link_to('rates', rates_url, { :new_path => new_rate_url })
				]})
			end

			@menu << link_to('invoice items', invoice_items_url, { :children => [
				link_to('work items', work_items_path, { :new_path => new_work_item_url }),
				link_to('expense items', expense_items_path, { :new_path => new_expense_item_url })
			]})

			if @current_user.admin?
				@menu << link_to("admin", nil, { :children => [ 
					link_to('users', users_url, { :new_path => new_user_url })
				]})
			end 
		end
    
    if logged_in?
      @menu << link_to(@current_user.login, user_path(@current_user))
      @menu << link_to('logout', logout_url)
    end
  end
  
end
