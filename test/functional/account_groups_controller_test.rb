require 'test_helper'

class AccountGroupsControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:account_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account group" do
    use_account_group :account_group_1
    params = { :name => 'new_account_group', :description => 'test new account group' }
    assert_difference('AccountGroup.count') do
      post :create, :account_group => params
    end

    account_group = AccountGroup.find(:first, :conditions => params)
    assert_equal account_group.users.first, users(:ag_1_admin)
    assert_redirected_to account_groups_path
    assert_equal 'Account Group was successfully created.', flash[:notice]
  end

  test "should show account group" do
    get :show, :id => account_groups(:account_group_1).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => account_groups(:account_group_1).to_param
    assert_response :success
  end

  test "should update account group" do
    put :update, :id => account_groups(:account_group_1).to_param, :account_group => { }
    assert_redirected_to account_groups_path
  end

  test "should destroy account group" do
    assert_difference('AccountGroup.count', -1) do
      delete :destroy, :id => account_groups(:account_group_1).to_param
    end

    assert_redirected_to account_groups_path
  end

  ## Fail tests for wrong account group

  test "should redirect on show account group using bad account group" do
    use_account_group :account_group_2
    get :show, :id => account_groups(:account_group_1).id
    assert_redirected_to root_path
  end

  test "should redirect on edit account group using bad account group" do
    use_account_group :account_group_2
    get :edit, :id => account_groups(:account_group_1).to_param
    assert_redirected_to root_path
  end

  test "should redirect on destroy account group using bad account group" do
    use_account_group :account_group_2
    delete :destroy, :id => account_groups(:account_group_1).to_param
    assert_redirected_to root_path
  end

  ## Fail tests for worker

  test "should fail on get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_nil assigns(:account_groups)
    assert_redirected_to root_path
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to root_path
  end

  test "should fail on create account group for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('AccountGroup.count') do
      post :create, :account_group => { :name => 'new_account_group', :description => 'test new account group' }
    end

    account = AccountGroup.find(:first, :conditions => { :name => 'new_account_group' })
    assert_nil account
    assert_redirected_to root_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should fail on show account group for worker" do
    login_as :ag_1_worker
    get :show, :id => account_groups(:account_group_1).id
    assert_redirected_to root_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => account_groups(:account_group_1).to_param
    assert_redirected_to root_path
  end

  test "should fail on update account group for worker" do
    login_as :ag_1_worker
    put :update, :id => account_groups(:account_group_1).to_param, :account_group => { }
    assert_redirected_to root_path
  end

  test "should fail on destroy account group for worker" do
    login_as :ag_1_worker
    assert_no_difference('AccountGroup.count', -1) do
      delete :destroy, :id => account_groups(:account_group_1).to_param
    end

    assert_redirected_to root_path
  end

end
