require 'test_helper'

class DetailTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:detail_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create detail_type" do
    assert_difference('DetailType.count') do
      post :create, :detail_type => { }
    end

    assert_redirected_to detail_type_path(assigns(:detail_type))
  end

  test "should show detail_type" do
    get :show, :id => detail_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => detail_types(:one).to_param
    assert_response :success
  end

  test "should update detail_type" do
    put :update, :id => detail_types(:one).to_param, :detail_type => { }
    assert_redirected_to detail_type_path(assigns(:detail_type))
  end

  test "should destroy detail_type" do
    assert_difference('DetailType.count', -1) do
      delete :destroy, :id => detail_types(:one).to_param
    end

    assert_redirected_to detail_types_path
  end
end
