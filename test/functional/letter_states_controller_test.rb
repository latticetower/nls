require 'test_helper'

class LetterStatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:letter_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create letter_state" do
    assert_difference('LetterState.count') do
      post :create, :letter_state => { }
    end

    assert_redirected_to letter_state_path(assigns(:letter_state))
  end

  test "should show letter_state" do
    get :show, :id => letter_states(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => letter_states(:one).to_param
    assert_response :success
  end

  test "should update letter_state" do
    put :update, :id => letter_states(:one).to_param, :letter_state => { }
    assert_redirected_to letter_state_path(assigns(:letter_state))
  end

  test "should destroy letter_state" do
    assert_difference('LetterState.count', -1) do
      delete :destroy, :id => letter_states(:one).to_param
    end

    assert_redirected_to letter_states_path
  end
end
