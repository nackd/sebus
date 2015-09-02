require 'test_helper'

class SebusControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get estimate" do
    get :estimate
    assert_response :success
  end

end
