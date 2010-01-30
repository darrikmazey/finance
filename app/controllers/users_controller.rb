class UsersController < ApplicationController
	
	before_filter :require_user, :except => [ :login ]

	def quick_switch
		reset_session
		session[:user_id] = params[:id]
		@current_user = User.find(params[:id])
		flash[:notice] = "you are now '#{@current_user.username}'"
		redirect_to :back
	end

	# GET /users/login
	def login
		if request.get?
			if @current_user
				redirect_to user_url(@current_user)
				return
			end
			@current_user = User.new
			render :action => 'login', :layout => 'login'
			return
		end
		if request.post?
			@current_user = User.authenticate(params[:user][:username], params[:user][:password])
			if @current_user.nil?
				flash[:error] = 'invalid username or password'
				render :action => 'login', :layout => 'login'
				return
			else
				session[:user_id] = @current_user.id
				flash[:notice] = "successfully logged in as user '#{@current_user.username}'"
				if session[:after_login]
					redirect_to session[:after_login]
				else
					redirect_to accounts_url
				end
			end
		end
	end

	# GET /users/logout
	def logout
		reset_session
		flash[:notice] = 'you have been logged out'
		redirect_to login_users_url
	end

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
