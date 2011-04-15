require 'test_helper'

class MeasuresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measure" do
    assert_difference('Measure.count') do
      post :create, :measure => { }
    end

    assert_redirected_to measure_path(assigns(:measure))
  end

  test "should show measure" do
    get :show, :id => measures(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => measures(:one).to_param
    assert_response :success
  end

  test "should update measure" do
    put :update, :id => measures(:one).to_param, :measure => { }
    assert_redirected_to measure_path(assigns(:measure))
  end

  test "should destroy measure" do
    assert_difference('Measure.count', -1) do
      delete :destroy, :id => measures(:one).to_param
    end

    assert_redirected_to measures_path
  end
end
