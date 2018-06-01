require "test_helper"

class Profiles::FollowersControllerTest < ActionDispatch::IntegrationTest
  test "seeing followers" do
    get user_followers_path("thorin")
    assert_response :ok

    assert_select "div.user", count: 2
    assert_select "p", text: users(:marty).name
    assert_select "p", text: users(:doc).name
  end

  test "seeing emtpy state" do
    get user_followers_path("cassian")

    assert_response :ok

    assert_select "div.card", count: 2

    assert_select "h3", text: /OH, MY FOLLOWERS/
    assert_select "p", text: /Invite your friends to join/
  end
end
