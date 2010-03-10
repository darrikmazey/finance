class AccountGroupsController < ApplicationController

  before_filter :login_required
  before_filter { |c| c.send(:admin_account_group_required, '/') if [:new, :create].include?(c.action_name) }

  def index
    @account_groups = @current_user.account_groups 
  end

  def show
    @account_group = AccountGroup.find(params[:id])
    @account_group = nil unless @current_user.account_groups.include?(@account_group)
    if @account_group.nil?
      redirect_to account_groups_url
      return
    end
  end
  
  def new
    @account_group = AccountGroup.new
    render :action => 'edit'
  end

  def edit
    @account_group = AccountGroup.find(params[:id])
    @account_group = nil unless @current_user.admin_account_groups.include?(@account_group)
    if @account_group.nil?
      redirect_to account_groups_url
      return
    end
  end

  def create
    @account_group = AccountGroup.new(params[:account_group])
    if @account_group.save
      @account_group.users << @current_user
      # make this the default account group if this the user's first
      if @current_user.account_groups.count == 0
        @current_user.account_group = @account_group
        @current_user.save
        @user_options.account_group_id = @account_group.id
        save_user_options
      end
      flash[:notice] = "Account Group was successfully created."
      puts "saved, redirecting"
      redirect_to account_groups_url
    else
      puts @current_user.inspect
      puts @account_group.errors.full_messages.inspect
      render :action => 'edit'
    end
  end

  def update
    @account_group = AccountGroup.find(params[:id])
    if @account_group.update_attributes(params[:account_group])
      flash[:notice] = "Account Group was successfully updated."
      redirect_to account_groups_url
    else
      render :action => "edit"
    end
  end

  def destroy
    @account_group = AccountGroup.find(params[:id])
    @account_group.destroy

    redirect_to account_groups_url
  end

  def add_account_group_admin
    @users = User.all
    if request.xhr?
      render :partial => 'account_groups/admins/form', :locals => { :users => @users, :id => params[:id] }
    end
  end
end
