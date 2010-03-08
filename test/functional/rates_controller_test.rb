require 'test_helper'

class RatesControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rate" do
    use_account_group :account_group_1
    assert_difference('Rate.count') do
      post :create, :rate => { :name => 'new_rate', :tax => 0.01, :project_id => projects(:ag_1_project_1).id, :modifier => 0.5, :taxeable => true }
    end

    rate = Rate.find(:first, :conditions => { :name => 'new_rate' })
    assert_equal rate.project.client.account.account_group, account_groups(:account_group_1)
    assert_redirected_to rates_path
    assert_equal 'Rate was successfully created.', flash[:notice]
  end

  test "should show rate" do
    get :show, :id => rates(:ag_1_rate_1).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => rates(:ag_1_rate_1).to_param
    assert_response :success
  end

  test "should update rate" do
    put :update, :id => rates(:ag_1_rate_1).to_param, :rate => { }
    assert_redirected_to rates_path
  end

  test "should destroy rate" do
    assert_difference('Rate.count', -1) do
      delete :destroy, :id => rates(:ag_1_rate_1).to_param
    end

    assert_redirected_to rates_path
  end

  ## Fail tests for wrong account group

  test "should redirect on show rate using bad account group" do
    use_account_group :account_group_2
    get :show, :id => rates(:ag_1_rate_1).id
    assert_redirected_to root_path
  end

  test "should redirect on edit rate using bad account group" do
    use_account_group :account_group_2
    get :edit, :id => rates(:ag_1_rate_1).to_param
    assert_redirected_to root_path
  end

  test "should redirect on destroy rate using bad account group" do
    use_account_group :account_group_2
    delete :destroy, :id => rates(:ag_1_rate_1).to_param
    assert_redirected_to root_path
  end

  ## Fail tests for worker

  test "should fail on get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_nil assigns(:rates)
    assert_redirected_to root_path
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to root_path
  end

  test "should fail on create rate for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('Rate.count') do
      post :create, :rate => { :name => 'new_rate', :tax => 0.01, :project_id => projects(:ag_1_project_1).id, :modifier => 0.5, :taxeable => true }
    end

    rate = Rate.find(:first, :conditions => { :name => 'new_rate' })
    assert_nil rate
    assert_redirected_to root_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should fail on show rate for worker" do
    login_as :ag_1_worker
    get :show, :id => rates(:ag_1_rate_1).id
    assert_redirected_to root_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => rates(:ag_1_rate_1).to_param
    assert_redirected_to root_path
  end

  test "should fail on update rate for worker" do
    login_as :ag_1_worker
    put :update, :id => rates(:ag_1_rate_1).to_param, :rate => { }
    assert_redirected_to root_path
  end

  test "should fail on destroy rate for worker" do
    login_as :ag_1_worker
    assert_no_difference('Rate.count', -1) do
      delete :destroy, :id => rates(:ag_1_rate_1).to_param
    end

    assert_redirected_to root_path
  end

end
