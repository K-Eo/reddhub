require "test_helper"

class PodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:eo)
  end

  class SignOut < PodsControllerTest
    def setup
      super
    end

    test "redirects on post create" do
      post pods_path, params: { pod: { content: "Foo bar"  } }

      assert_redirected_to new_user_session_path
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

      assert_redirected_to user_path(@user.username)
    end
  end
end
