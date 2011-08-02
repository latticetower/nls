require 'test_helper'

class OrganizationDetailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_detail" do
    assert_difference('OrganizationDetail.count') do
      post :create, :organization_detail => { }
    end

    assert_redirected_to organization_detail_path(assigns(:organization_detail))
  end

  test "should show organization_detail" do
    get :show, :id => organization_details(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => organization_details(:one).to_param
    assert_response :success
  end

  test "should update organization_detail" do
    put :update, :id => organization_details(:one).to_param, :organization_detail => { }
    assert_redirected_to organization_detail_path(assigns(:organization_detail))
  end

  test "should destroy organization_detail" do
    assert_difference('OrganizationDetail.count', -1) do
      delete :destroy, :id => organization_details(:one).to_param
    end

    assert_redirected_to organization_details_path
  end
end
