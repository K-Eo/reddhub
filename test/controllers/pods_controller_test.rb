require "test_helper"

class PodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  class SignOut < PodsControllerTest
    def setup
      super
    end

    test "redirects on post create" do
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

    test "should create a pod" do
      assert_difference "Pod.count" do
        post pods_path, params: { pod: { content: "Foo bar"  } }
      end

      assert_redirected_to user_profile_path(@user.username)
    end

    test "should create a pod xhr" do
      assert_difference "Pod.count" do
        post pods_path, params: { pod: { content: "Foo bar"  } }, xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
      assert_match /window\.location\.replace.*#{@user.username}/, @response.body
    end
  end
end
