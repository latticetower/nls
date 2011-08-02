require 'test_helper'

class HistoryLogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:history_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create history_log" do
    assert_difference('HistoryLog.count') do
      post :create, :history_log => { }
    end

    assert_redirected_to history_log_path(assigns(:history_log))
  end

  test "should show history_log" do
    get :show, :id => history_logs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => history_logs(:one).to_param
    assert_response :success
  end

  test "should update history_log" do
    put :update, :id => history_logs(:one).to_param, :history_log => { }
    assert_redirected_to history_log_path(assigns(:history_log))
  end

  test "should destroy history_log" do
    assert_difference('HistoryLog.count', -1) do
      delete :destroy, :id => history_logs(:one).to_param
    end

    assert_redirected_to history_logs_path
  end
end
