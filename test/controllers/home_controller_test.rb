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
  end
end
