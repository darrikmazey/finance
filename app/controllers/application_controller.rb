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

	private

	def load_user
		@current_user = User.find(session[:user_id]) rescue nil
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
	end

end
