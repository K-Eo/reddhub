require "test_helper"

class Pods::LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
    @pod = pods(:one)
  end

  class SignOut < Pods::LikesControllerTest
    def setup
      super
    end

    test "redirects when create like" do
      assert_no_difference "Like.count" do
        post pod_like_path(@pod)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirects when create like xhr" do
      assert_no_difference "Like.count" do
        post pod_like_path(@pod), xhr: true
      end

      assert_response :unauthorized
    end

    test "redirects when destroy like" do
      assert_no_difference "Like.count" do
        delete pod_like_path(@pod)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirects when destroy like xhr" do
      assert_no_difference "Like.count" do
        delete pod_like_path(@pod), xhr: true
      end

      assert_response :unauthorized
    end
  end

  class SignIn < Pods::LikesControllerTest
    def setup
      super
      sign_in @user
    end

    test "creates like" do
      assert_difference "Like.count" do
        post pod_like_path(@pod)
      end

      assert_redirected_to user_path(@user.username)
    end

    test "creates like xhr" do
      assert_difference "Like.count" do
        post pod_like_path(@pod), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "destroys like" do
      @pod.likes.create!(user: @user)

      assert_difference "Like.count", -1 do
        delete pod_like_path(@pod)
      end

      assert_redirected_to user_path(@user.username)
    end

    test "destroys like xhr" do
      @pod.likes.create!(user: @user)

      assert_difference "Like.count", -1 do
        delete pod_like_path(@pod), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end
  end
end
