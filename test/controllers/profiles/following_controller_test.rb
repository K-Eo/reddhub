require "test_helper"

class Profiles::FollowingControllerTest < ActionDispatch::IntegrationTest
  test "seeing following" do
    get user_following_path("marty")
    assert_response :ok

    assert_select "div.user", count: 2
    assert_select "p", text: users(:doc).name
    assert_select "p", text: users(:thorin).name
  end

  test "seeing empty state" do
    get user_following_path("cassian")

    assert_response :ok

    assert_select "div.card", count: 2

    assert_select "h3", text: /Where are they\?/
    assert_select "p", text: /You can find interesting people to follow/
  end
end
