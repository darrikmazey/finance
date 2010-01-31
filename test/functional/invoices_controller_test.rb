require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
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
    assert_difference('Invoice.count') do
      post :create, :invoice => { }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, :id => invoices(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => invoices(:one).to_param
    assert_response :success
  end

  test "should update invoice" do
    put :update, :id => invoices(:one).to_param, :invoice => { }
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, :id => invoices(:one).to_param
    end

    assert_redirected_to invoices_path
  end
end
