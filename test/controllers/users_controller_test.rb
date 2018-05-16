require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "should get show" do
    get user_path(@user.username)
    assert_response :success
  end

  test "should redirect to 404 if user does not exist" do
    get user_path("foo")
    assert_response :not_found
  end
end
