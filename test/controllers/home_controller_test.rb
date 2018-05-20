require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  class LoggedOut < HomeControllerTest
    test "render landing page" do
      get root_path
      assert_response :success

      assert_select "h1", text: "Welcome to ReddHub"
    end
  end

  class LoggedIn < HomeControllerTest
    setup do
      @user = users(:bilbo)
      sign_in @user
    end

    test "render user card" do
      get root_path
      assert_response :success

      assert_select "img[src*=gravatar]"
      assert_select "p", text: "Bilbo Baggins"
      assert_select "p", text: "@Bilbo"
      assert_select "div", text: "Followers"
      assert_select "div", text: "0"
      assert_select "div", text: "Following"
      assert_select "div", text: "0"
    end

    test "navigate to user profile" do
      @user.pods.create(content: "My Pod")
      get root_path

      assert_response :success
      assert_select "a", text: "@Bilbo"

      get user_path(@user.username)

      assert_response :success

      assert_select "a.nav-item.active", text: "Pods1"
      assert_select "a.nav-item", text: "Following0"
      assert_select "a.nav-item", text: "Followers0"
    end

    test "render pods" do
      get root_path

      assert_response :success

      assert_select "a", text: "Bilbo Baggins", count: 2
      assert_select "p", text: "First pod"
      assert_select "p", text: "Second pod"

      assert_select "h6", text: "Thorin", count: 0
      assert_select "h6", text: "Marty", count: 0
      assert_select "h6", text: "Emmett", count: 0
    end

    test "seeing followers" do
      @marty = users(:marty)
      @marty.follow(@user)

      get root_path

      assert_response :ok
      assert_select "a[href='/#{@user.username}/followers']", text: "Followers1"

      get user_followers_path(@user.username)

      assert_response :ok

      assert_select "a.nav-item.active", text: "Followers1"

      assert_select "div[id=user_card_#{@marty.id}]" do
        assert_select "p", text: /Marty Mcfly/
        assert_select "a", text: "Following1"
        assert_select "a", text: "Followers0"
        assert_select "a[href='/#{@marty.username}/relationship'][data-method=post]", text: "Follow"
      end
    end

    test "seeing following" do
      @marty = users(:marty)
      @user.follow(@marty)
      @user.reload

      get root_path

      assert_response :ok
      assert_select "a[href='/#{@user.username}/following']", text: "Following1"

      get user_following_path(@user.username)

      assert_response :ok

      assert_select "a.nav-item.active", text: "Following1"

      assert_select "div[id=user_card_#{@marty.id}]" do
        assert_select "p", text: /Marty Mcfly/
        assert_select "a", text: "Following0"
        assert_select "a", text: "Followers1"
        assert_select "a[href='/#{@marty.username}/relationship'][data-method=delete]", text: "Unfollow"
      end
    end
  end
end
