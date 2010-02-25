class AccountGroupsController < ApplicationController

  before_filter :require_user

  def index
    @account_groups = @current_user.account_groups 
  end

  def show
    @account_group = @current_user.account_groups.find(params[:id]) rescue nil
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
    @account_group = @current_user.account_groups.find(params[:id]) rescue nil
    if @account_group.nil?
      redirect_to account_groups_url
      return
    end
  end

  def create
    @account_group = AccountGroup.new(params[:account_group])
    @account_group.users << @current_user
    if @account_group.save
      flash[:notice] = "Account Group was successfully created."
      redirect_to account_groups_url
    else
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
end
