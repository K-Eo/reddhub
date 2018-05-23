require "test_helper"

class Profiles::PodsControllerTest < ActionDispatch::IntegrationTest
  test "seeing pod" do
    @user = users(:bilbo)
    @pod = @user.pods.first

    get user_profile_path(@user.username)

    assert_response :ok

    assert_select "p", text: @pod.content
    assert_select ".pod", count: 2

    get user_pod_path(@user.username, @pod)

    assert_response :ok

    assert_select ".pod", count: 0
    assert_select ".card" do
      assert_select "a[href='/#{@user.username}']" do
        assert_select "p", text: @user.name
        assert_select "p", text: "@#{@user.username}"
      end

      assert_select "p", text: @pod.content

      assert_select "a.like-action"
    end
  end
end
