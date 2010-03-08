require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction" do
    use_account_group :account_group_1
    assert_difference('Transaction.count') do
      post :create, :transaction => { :debit_account_id => accounts(:ag_1_client_account).id, :credit_account_id => accounts(:ag_1_checking).id, :ref => 12345, :amount => 45.00, :invoice_id => invoices(:ag_1_invoice_1).id, :trans_date => Time.now(), :description => 'test new transaction' }
    end

    transaction = Transaction.find(:first, :conditions => { :ref => 12345 })
    assert_equal transaction.invoice.project.client.account.account_group, account_groups(:account_group_1)
    assert_redirected_to transactions_path
    assert_equal 'Transaction was successfully created.', flash[:notice]
  end

  test "should show transaction" do
    get :show, :id => transactions(:ag_1_transaction_1).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => transactions(:ag_1_transaction_1).to_param
    assert_response :success
  end

  test "should update transaction" do
    put :update, :id => transactions(:ag_1_transaction_1).to_param, :transaction => { }
    assert_redirected_to transactions_path
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete :destroy, :id => transactions(:ag_1_transaction_1).to_param
    end

    assert_redirected_to transactions_path
  end

  ## Fail tests for wrong account group

  test "should redirect on show transaction using bad account group" do
    use_account_group :account_group_2
    get :show, :id => transactions(:ag_1_transaction_1).id
    assert_redirected_to root_path
  end

  test "should redirect on edit transaction using bad account group" do
    use_account_group :account_group_2
    get :edit, :id => transactions(:ag_1_transaction_1).to_param
    assert_redirected_to root_path
  end

  test "should redirect on destroy transaction using bad account group" do
    use_account_group :account_group_2
    delete :destroy, :id => transactions(:ag_1_transaction_1).to_param
    assert_redirected_to root_path
  end

  ## Fail tests for worker

  test "should fail on get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_nil assigns(:transactions)
    assert_redirected_to root_path
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to root_path
  end

  test "should fail on create transaction for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('Transaction.count') do
      post :create, :transaction => { :debit_account_id => accounts(:ag_1_client_account).id, :credit_account_id => accounts(:ag_1_checking).id, :ref => 12345, :amount => 45.00, :invoice_id => invoices(:ag_1_invoice_1).id, :trans_date => Time.now(), :description => 'test new transaction' }
    end

    transaction = Transaction.find(:first, :conditions => { :ref => 12345 })
    assert_nil transaction
    assert_redirected_to root_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should fail on show transaction for worker" do
    login_as :ag_1_worker
    get :show, :id => transactions(:ag_1_transaction_1).id
    assert_redirected_to root_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => transactions(:ag_1_transaction_1).to_param
    assert_redirected_to root_path
  end

  test "should fail on update transaction for worker" do
    login_as :ag_1_worker
    put :update, :id => transactions(:ag_1_transaction_1).to_param, :transaction => { }
    assert_redirected_to root_path
  end

  test "should fail on destroy transaction for worker" do
    login_as :ag_1_worker
    assert_no_difference('Transaction.count', -1) do
      delete :destroy, :id => transactions(:ag_1_transaction_1).to_param
    end

    assert_redirected_to root_path
  end

end
