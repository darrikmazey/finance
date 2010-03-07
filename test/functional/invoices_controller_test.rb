require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    use_account_group :account_group_1
    assert_difference('Invoice.count') do
      post :create, :invoice => { :identifier => '135', :project_id => projects(:ag_1_project_1).id }
    end

    invoice = Invoice.find(:first, :conditions => { :identifier => '135' })
    assert_equal invoice.project.client.account.account_group, account_groups(:account_group_1)
    assert_redirected_to invoices_path
    assert_equal 'Invoice was successfully created.', flash[:notice]
  end

  test "should show invoice" do
    get :show, :id => invoices(:ag_1_invoice_1).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => invoices(:ag_1_invoice_1).to_param
    assert_response :success
  end

  test "should update invoice" do
    put :update, :id => invoices(:ag_1_invoice_1).to_param, :invoice => { }
    assert_redirected_to invoices_path
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, :id => invoices(:ag_1_invoice_1).to_param
    end

    assert_redirected_to invoices_path
  end

  ## Fail tests for wrong account group

  test "should redirect on show invoice using bad account group" do
    use_account_group :account_group_2
    get :show, :id => invoices(:ag_1_invoice_1).id
    assert_redirected_to root_path
  end

  test "should redirect on edit invoice using bad account group" do
    use_account_group :account_group_2
    get :edit, :id => invoices(:ag_1_invoice_1).to_param
    assert_redirected_to root_path
  end

  test "should redirect on destroy invoice using bad account group" do
    use_account_group :account_group_2
    delete :destroy, :id => invoices(:ag_1_invoice_1).to_param
    assert_redirected_to root_path
  end

  ## Fail tests for worker

  test "should fail on get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_nil assigns(:invoices)
    assert_redirected_to root_path
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to root_path
  end

  test "should fail on create invoice for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('Invoice.count') do
      post :create, :invoice => { :identifier => '135', :project_id => projects(:ag_1_project_1).id }
    end

    invoice = Invoice.find(:first, :conditions => { :identifier => '135' })
    assert_nil invoice
    assert_redirected_to root_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should fail on show invoice for worker" do
    login_as :ag_1_worker
    get :show, :id => invoices(:ag_1_invoice_1).id
    assert_redirected_to root_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => invoices(:ag_1_invoice_1).to_param
    assert_redirected_to root_path
  end

  test "should fail on update invoice for worker" do
    login_as :ag_1_worker
    put :update, :id => invoices(:ag_1_invoice_1).to_param, :invoice => { }
    assert_redirected_to root_path
  end

  test "should fail on destroy invoice for worker" do
    login_as :ag_1_worker
    assert_no_difference('Invoice.count', -1) do
      delete :destroy, :id => invoices(:ag_1_invoice_1).to_param
    end

    assert_redirected_to root_path
  end

end
