require "test_helper"

class Users::FollowingControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "should get show" do
    get user_following_path(@user.username)
    assert_response :success
  end
end
