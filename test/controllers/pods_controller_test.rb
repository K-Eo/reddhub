require "test_helper"

class PodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  class SignOut < PodsControllerTest
    def setup
      super
    end

    test "redirects to login on post create" do
      post pods_path, params: { pod: { content: "Foo bar"  } }

      assert_redirected_to new_user_session_path
    end

    test "unauthorized on post create" do
      post pods_path, params: { pod: { content: "Foo bar"  } }, xhr: true

      assert_response :unauthorized
    end
  end

  class SignIn < PodsControllerTest
    def setup
      super
      sign_in @user
    end

    test "creating pod" do
      get root_path

      assert_response :ok

      assert_select "li.pod", count: 2
      assert_select "form#new_pod" do
        assert_select "input#pod_content"
      end

      assert_difference "@user.pods.count" do
        post pods_path, params: { pod: { content: "Foo bar"  } }
      end

      assert_redirected_to root_path

      follow_redirect!

      assert_select "li.pod", count: 3
      assert_select "li.pod" do
        assert_select "p", text: "Foo bar"
      end

      assert_select "div.alert-notice", text: /Pod was successfully created/
    end

    test "creating pod with error" do
      get root_path

      assert_response :ok

      assert_select "li.pod", count: 2
      assert_select "form#new_pod" do
        assert_select "input#pod_content"
      end

      assert_no_difference "@user.pods.count" do
        post pods_path, params: { pod: { content: ""  } }
      end

      assert_response :success

      assert_select "li.pod", count: 2
      assert_select "div", text: /can't be blank/

      assert_no_difference "@user.pods.count" do
        post pods_path, params: { pod: { content: ("a" * 257) } }
      end

      assert_response :success

      assert_select "li.pod", count: 2
      assert_select "div", text: /is too long/
    end
  end
end
