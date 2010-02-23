# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'finance_classes'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
	
	before_filter :load_user
	before_filter :preload
	before_filter :get_version

	private

	def load_user
		@current_user = User.find(session[:user_id]) rescue nil
    if @current_user
      # create a hash of options, start with the defaults, merge in session and then merg in params
      h = @current_user.user_options
      h.merge!(session[:user_option]) if session[:user_option]

      # stringify the params user options
      p = {}
      params[:user_option].each { |k, v| p[k.to_s] = v } if params[:user_option]
      h.merge!(p) if p
      @user_options = UserOption.new(h)

      # save this in the session
      session[:user_option] = @user_options.attributes

      render :partial => 'account_groups/no_account_groups', :layout => true  unless @user_options.account_group
    end
	end

	def require_user
		if @current_user.nil?
			flash[:error] = 'authentication required'
			session[:after_login] = request.url
			redirect_to login_users_url
			return
		end
	end

	def preload
		if @current_user
			if params[:user_id]
				if params[:user_id].to_i != @current_user.id.to_i
					flash[:error] = "that doesn't belong to you.  eyes on your own paper!"
					redirect_to user_accounts_url(@current_user)
				end
			end
			@user = @current_user
		else
			if params[:user_id]
				@user = User.find params[:user_id] rescue nil
			end
		end
		if params[:account_id]
			@account = Account.find params[:account_id] rescue nil
		end
		if params[:period]
			@period = Period[params[:period].to_i]
		end
		if params[:work_item_id]
			@work_item = WorkItem.find params[:work_item_id] rescue nil
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

end
