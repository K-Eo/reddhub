require "test_helper"

class Profiles::FollowingControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "should get show" do
    get user_following_path(@user.username)
    assert_response :success
  end

  test "seeing empty state" do
    get user_following_path("cassian")

    assert_response :ok

    assert_select "div.card", count: 2

    assert_select "h3", text: /Where are they\?/
    assert_select "p", text: /You can find interesting people to follow/
  end
end
