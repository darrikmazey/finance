class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :show, :update]
  before_filter :self_or_admin_required, :only => [:edit, :show, :update]
  before_filter :admin_required, :only => [:index]

  # render new.rhtml
  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def index
    @users = User.all
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.


  def update
    success = false
    password_issue = false
    if params[:user]
      old_pass = params[:user].delete(:old_password)
      pass = params[:user].delete(:password)
      pass_conf = params[:user].delete(:password_confirmation)

      # only do password change stuff if there is an old password given
      if !old_pass.blank?
        if User.authenticate(@current_user.login, old_pass)
          if ((pass == pass_conf) && !pass_conf.blank?)
            @user.password_confirmation = pass_conf
            @user.password = pass
          else
            flash[:error] = "Passwords do not match."
            password_issue = true
          end
        else
          password_issue = true
          flash[:error] = "Password error."
        end
      end

      # if they tried to update the password and failed then just keep failing, 
      # don't also try to update the rest of the attributes
      if !password_issue && @user.update_attributes(params[:user])
        flash[:notice] = "User was successfully updated."
        success = true
      end
    end
    if success
      redirect_to(user_path(@current_user))
    else
      render :action => 'edit'
    end
  end

  def update2
     if User.authenticate(current_user.login, params[:old_password])
        if ((params[:password] == params[:password_confirmation]) && 
                              !params[:password_confirmation].blank?)
          current_user.password_confirmation = params[:password_confirmation]
          current_user.password = params[:password]

          if current_user.save
            flash[:notice] = "Password successfully updated" 
            redirect_to profile_url(current_user.login)
          else
            flash[:alert] = "Password not changed" 
          end

        else
          flash[:alert] = "New Password mismatch" 
          @old_password = params[:old_password]
        end
      else
        flash[:alert] = "Old password incorrect" 
      end        
  end

protected
  def find_user
    @user = User.find(params[:id])
  end
end
