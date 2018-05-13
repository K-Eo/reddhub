require "test_helper"

class Users::FollowersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:eo)
  end

  test "should get show" do
    get user_followers_path(@user.username)
    assert_response :success
  end
end
