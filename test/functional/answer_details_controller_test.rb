require 'test_helper'

class AnswerDetailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:answer_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create answer_detail" do
    assert_difference('AnswerDetail.count') do
      post :create, :answer_detail => { }
    end

    assert_redirected_to answer_detail_path(assigns(:answer_detail))
  end

  test "should show answer_detail" do
    get :show, :id => answer_details(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => answer_details(:one).to_param
    assert_response :success
  end

  test "should update answer_detail" do
    put :update, :id => answer_details(:one).to_param, :answer_detail => { }
    assert_redirected_to answer_detail_path(assigns(:answer_detail))
  end

  test "should destroy answer_detail" do
    assert_difference('AnswerDetail.count', -1) do
      delete :destroy, :id => answer_details(:one).to_param
    end

    assert_redirected_to answer_details_path
  end
end
