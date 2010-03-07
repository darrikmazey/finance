require 'test_helper'

class ClientsControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    use_account_group :account_group_1
    assert_difference('Client.count') do
      post :create, :client => { :name => 'new_client', :contact_city => 'city1', :contact_last_name => 'last name', :contact_first_name => 'first name', :contact_zipcode => '06790', :contact_street1 => 'street 1', :contact_street2 => 'street 2', :contact_state => 'ct', :account => accounts(:ag_1_client_account) }
    end

    client = Client.find(:first, :conditions => { :name => 'new_client' })
    assert_equal client.account.account_group, account_groups(:account_group_1)
    assert_redirected_to clients_path
    assert_equal 'Client was successfully created.', flash[:notice]
  end

  test "should show client" do
    get :show, :id => clients(:ag_1_client_1).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => clients(:ag_1_client_1).to_param
    assert_response :success
  end

  test "should update client" do
    put :update, :id => clients(:ag_1_client_1).to_param, :client => { }
    assert_redirected_to clients_path
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, :id => clients(:ag_1_client_1).to_param
    end

    assert_redirected_to clients_path
  end

  ## Fail tests for wrong client group

  test "should redirect on show client using bad client group" do
    use_account_group :account_group_2
    get :show, :id => clients(:ag_1_client_1).id
    assert_redirected_to root_path
  end

  test "should redirect on edit client using bad client group" do
    use_account_group :account_group_2
    get :edit, :id => clients(:ag_1_client_1).to_param
    assert_redirected_to root_path
  end

  test "should redirect on destroy client using bad client group" do
    use_account_group :account_group_2
    delete :destroy, :id => clients(:ag_1_client_1).to_param
    assert_redirected_to root_path
  end

  ## Fail tests for worker

  test "should fail on get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_nil assigns(:clients)
    assert_redirected_to root_path
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to root_path
  end

  test "should fail on create client for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('Client.count') do
      post :create, :client => { :name => 'new_client', :description => 'test new client', :initial_balance => 0.0, :type => 'ExpenseClient', :due_date => Time.now, :period => 1, :client_number => 11235, :amount => 0.0 }
    end

    client = Client.find(:first, :conditions => { :name => 'new_client' })
    assert_nil client
    assert_redirected_to root_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should fail on show client for worker" do
    login_as :ag_1_worker
    get :show, :id => clients(:ag_1_client_1).id
    assert_redirected_to root_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => clients(:ag_1_client_1).to_param
    assert_redirected_to root_path
  end

  test "should fail on update client for worker" do
    login_as :ag_1_worker
    put :update, :id => clients(:ag_1_client_1).to_param, :client => { }
    assert_redirected_to root_path
  end

  test "should fail on destroy client for worker" do
    login_as :ag_1_worker
    assert_no_difference('Client.count', -1) do
      delete :destroy, :id => clients(:ag_1_client_1).to_param
    end

    assert_redirected_to root_path
  end

end
