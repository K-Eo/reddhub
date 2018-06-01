require "test_helper"

class Profiles::FollowersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "should get show" do
    get user_followers_path(@user.username)
    assert_response :success
  end

  test "seeing emtpy state" do
    get user_followers_path("cassian")

    assert_response :ok

    assert_select "div.card", count: 2

    assert_select "h3", text: /OH, MY FOLLOWERS/
    assert_select "p", text: /Invite your friends to join/
  end
end
