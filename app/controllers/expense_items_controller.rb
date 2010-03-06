class ExpenseItemsController < ApplicationController

  before_filter :login_required

  def index
    @list_type = :loose
    @expense_items = @current_user.loose_expense_items_for_account_group(@user_options.account_group) 
  end

  def all
    @list_type = :all
    @expense_items = @current_user.expense_items_for_account_group(@user_options.account_group)
    render :action => :index
  end

  def show
    @expense_item = @current_user.expense_items.find(params[:id]) rescue nil
    @expense_item = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@expense_item.project)

    if @expense_item.nil?
      redirect_to invoice_items_url
      return
    end
  end

  def new
    @expense_item = ExpenseItem.new
    @expense_item.user = @current_user
    @expense_item.project = @current_user.last_project || @current_user.projects.first

    # make sure they can access the project
    projects = @current_user.projects_for_account_group(@user_options.account_group)
    @expense_item.project = projects.first unless projects.include?(@expense_item.project)

    render :action => 'edit'
  end

  def edit
    @expense_item = @current_user.expense_items.find(params[:id]) rescue nil
    @expense_item = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@expense_item.project)
    if @expense_item.nil?
      redirect_to invoice_items_url
      return
    end
  end

  def create
    @expense_item = ExpenseItem.new(params[:expense_item])
    if @expense_item.save
      flash[:notice] = "Expense item was successfully created."
      redirect_to invoice_items_url
    else
      render :action => 'edit'
    end
  end

  def update
    @expense_item = ExpenseItem.find(params[:id])
    if @expense_item.update_attributes(params[:expense_item])
      flash[:notice] = "Expense item was successfully updated."
      redirect_to(expense_item_url)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @expense_item = ExpenseItem.find(params[:id])
    @expense_item = nil unless @current_user == @expense_item.user || @user_options.admin_account_group?
    if @expense_item.nil?
      redirect_to invoice_items_url
      return
    end

    @expense_item.destroy
    redirect_to invoice_items_url
  end
end

