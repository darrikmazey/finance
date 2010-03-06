class InvoiceItemsController < ApplicationController

	before_filter :login_required

  def index
		@list_type = :loose
    @work_items = @current_user.loose_work_items_for_account_group(@user_options.account_group)
    @expense_items = @current_user.loose_expense_items_for_account_group(@user_options.account_group)
  end
end
