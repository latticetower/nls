require 'test_helper'

class BoxingTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boxing_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boxing_type" do
    assert_difference('BoxingType.count') do
      post :create, :boxing_type => { }
    end

    assert_redirected_to boxing_type_path(assigns(:boxing_type))
  end

  test "should show boxing_type" do
    get :show, :id => boxing_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => boxing_types(:one).to_param
    assert_response :success
  end

  test "should update boxing_type" do
    put :update, :id => boxing_types(:one).to_param, :boxing_type => { }
    assert_redirected_to boxing_type_path(assigns(:boxing_type))
  end

  test "should destroy boxing_type" do
    assert_difference('BoxingType.count', -1) do
      delete :destroy, :id => boxing_types(:one).to_param
    end

    assert_redirected_to boxing_types_path
  end
end
