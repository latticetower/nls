require 'test_helper'

class LetterDetailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:letter_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create letter_detail" do
    assert_difference('LetterDetail.count') do
      post :create, :letter_detail => { }
    end

    assert_redirected_to letter_detail_path(assigns(:letter_detail))
  end

  test "should show letter_detail" do
    get :show, :id => letter_details(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => letter_details(:one).to_param
    assert_response :success
  end

  test "should update letter_detail" do
    put :update, :id => letter_details(:one).to_param, :letter_detail => { }
    assert_redirected_to letter_detail_path(assigns(:letter_detail))
  end

  test "should destroy letter_detail" do
    assert_difference('LetterDetail.count', -1) do
      delete :destroy, :id => letter_details(:one).to_param
    end

    assert_redirected_to letter_details_path
  end
end
