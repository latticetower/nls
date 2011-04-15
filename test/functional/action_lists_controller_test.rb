require 'test_helper'

class ActionListsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:action_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create action_list" do
    assert_difference('ActionList.count') do
      post :create, :action_list => { }
    end

    assert_redirected_to action_list_path(assigns(:action_list))
  end

  test "should show action_list" do
    get :show, :id => action_lists(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => action_lists(:one).to_param
    assert_response :success
  end

  test "should update action_list" do
    put :update, :id => action_lists(:one).to_param, :action_list => { }
    assert_redirected_to action_list_path(assigns(:action_list))
  end

  test "should destroy action_list" do
    assert_difference('ActionList.count', -1) do
      delete :destroy, :id => action_lists(:one).to_param
    end

    assert_redirected_to action_lists_path
  end
end
