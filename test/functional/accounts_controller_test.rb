require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    use_account_group :account_group_1
    assert_difference('Account.count') do
      post :create, :account => { :name => 'new_account', :description => 'test new account', :initial_balance => 0.0, :type => 'ExpenseAccount', :due_date => Time.now, :period => 1, :account_number => 11235, :amount => 0.0 }
    end

    account = Account.find(:first, :conditions => { :name => 'new_account' })
    assert_equal account.account_group, account_groups(:account_group_1)
    assert_redirected_to accounts_path
    assert_equal 'Account was successfully created.', flash[:notice]
  end

  test "should show account" do
    get :show, :id => accounts(:ag_1_checking).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accounts(:ag_1_checking).to_param
    assert_response :success
  end

  test "should update account" do
    put :update, :id => accounts(:ag_1_checking).to_param, :account => { }
    assert_redirected_to accounts_path
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, :id => accounts(:ag_1_checking).to_param
    end

    assert_redirected_to accounts_path
  end

  ## Fail tests for wrong account group

  test "should redirect on show account using bad account group" do
    use_account_group :account_group_2
    get :show, :id => accounts(:ag_1_checking).id
    assert_redirected_to root_path
  end

  test "should redirect on edit account using bad account group" do
    use_account_group :account_group_2
    get :edit, :id => accounts(:ag_1_checking).to_param
    assert_redirected_to root_path
  end

  test "should redirect on destroy account using bad account group" do
    use_account_group :account_group_2
    delete :destroy, :id => accounts(:ag_1_checking).to_param
    assert_redirected_to root_path
  end

  ## Fail tests for worker

  test "should fail on get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_nil assigns(:accounts)
    assert_redirected_to root_path
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to root_path
  end

  test "should fail on create account for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('Account.count') do
      post :create, :account => { :name => 'new_account', :description => 'test new account', :initial_balance => 0.0, :type => 'ExpenseAccount', :due_date => Time.now, :period => 1, :account_number => 11235, :amount => 0.0 }
    end

    account = Account.find(:first, :conditions => { :name => 'new_account' })
    assert_nil account
    assert_redirected_to root_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should fail on show account for worker" do
    login_as :ag_1_worker
    get :show, :id => accounts(:ag_1_checking).id
    assert_redirected_to root_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => accounts(:ag_1_checking).to_param
    assert_redirected_to root_path
  end

  test "should fail on update account for worker" do
    login_as :ag_1_worker
    put :update, :id => accounts(:ag_1_checking).to_param, :account => { }
    assert_redirected_to root_path
  end

  test "should fail on destroy account for worker" do
    login_as :ag_1_worker
    assert_no_difference('Account.count', -1) do
      delete :destroy, :id => accounts(:ag_1_checking).to_param
    end

    assert_redirected_to root_path
  end

end
