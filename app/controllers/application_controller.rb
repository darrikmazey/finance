# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'finance_classes'

class ApplicationController < ActionController::Base

  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
	
	before_filter :load_user
	before_filter :get_version

	private

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
      session[:user_option] = @user_options.attributes
  
      render :partial => 'account_groups/no_account_groups', :layout => true unless @user_options.account_group
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
    if !@user_options.admin_account_group?
      flash[:error] = "You are only a worker, you do not have permission to do that!"
      redirect_to path
    end
  end

  def admin_account_group_required_redirect_root
    if !@user_options.admin_account_group?
      flash[:error] = "You are only a worker, you do not have permission to do that!"
      redirect_to '/'
    end
  end
  
end
