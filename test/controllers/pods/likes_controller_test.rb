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

    test "redirect to login on create like" do
      assert_no_difference "Like.count" do
        post pod_like_path(@pod)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login on create like with xhr" do
      assert_no_difference "Like.count" do
        post pod_like_path(@pod), xhr: true
      end

      assert_response :unauthorized
    end

    test "redirect to login on destroy like" do
      assert_no_difference "Like.count" do
        delete pod_like_path(@pod)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login on destroy like with xhr" do
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

    test "creating like on pod" do
      get user_profile_path(@user.username)

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a.like-action#pod_likes_#{@pod.id}", text: ""
      end

      assert_difference "@pod.likes.count" do
        post pod_like_path(@pod)
      end

      assert_redirected_to user_profile_path(@user.username)

      follow_redirect!

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a.like-action#pod_likes_#{@pod.id}", text: "1"
      end
    end

    test "creating like on pod view" do
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "div.pod-actions" do
        assert_select "a.like-action", text: ""
      end

      assert_difference "@pod.likes.count" do
        post pod_like_path(@pod), headers: { "HTTP_REFERER" => user_pod_path(@user.username, @pod) }
      end

      assert_redirected_to user_pod_path(@user.username, @pod)

      follow_redirect!

      assert_select "div.pod-actions" do
        assert_select "a.like-action", text: "1"
      end
    end

    test "creating like on pod with xhr" do
      assert_difference "@pod.likes.count" do
        post pod_like_path(@pod), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "destroying like on pod" do
      @pod.likes.create!(user: @user)

      get user_profile_path(@user.username)

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a.like-action#pod_likes_#{@pod.id}", text: "1"
      end

      assert_difference "@pod.likes.count", -1 do
        delete pod_like_path(@pod)
      end

      assert_redirected_to user_profile_path(@user.username)

      follow_redirect!

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a.like-action#pod_likes_#{@pod.id}", text: ""
      end
    end

    test "destroying like on pod with xhr" do
      @pod.likes.create!(user: @user)

      assert_difference "@pod.likes.count", -1 do
        delete pod_like_path(@pod), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "destroying like on pod view" do
      @pod.likes.create!(user: @user)
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "div.pod-actions" do
        assert_select "a.like-action", text: "1"
      end

      assert_difference "@pod.likes.count", -1 do
        delete pod_like_path(@pod), headers: { "HTTP_REFERER" => user_pod_path(@user.username, @pod) }
      end

      assert_redirected_to user_pod_path(@user.username, @pod)

      follow_redirect!

      assert_select "div.pod-actions" do
        assert_select "a.like-action", text: ""
      end
    end
  end
end
