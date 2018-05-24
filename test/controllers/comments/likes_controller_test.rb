require "test_helper"

class Comments::LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
    @pod = pods(:one)
    @comment = @pod.comments.create!(user: @user, body: "My comment")
  end

  class LoggedOut < Comments::LikesControllerTest
    def setup
      super
    end

    test "redirect to login when creating like" do
      assert_no_difference "@comment.likes.count" do
        post comment_like_path(@comment)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login when creating like with xhr" do
      assert_no_difference "@comment.likes.count" do
        post comment_like_path(@comment), xhr: true
      end

      assert_response :unauthorized
    end

    test "redirect to login when destroying like" do
      assert_no_difference "@comment.likes.count" do
        delete comment_like_path(@comment)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login when destroying like with xhrk" do
      assert_no_difference "@comment.likes.count" do
        delete comment_like_path(@comment), xhr: true
      end

      assert_response :unauthorized
    end
  end

  class LoggedIn < Comments::LikesControllerTest
    def setup
      super
      sign_in(@user)
    end

    def pod_path
      user_pod_path(@user.username, @pod)
    end

    test "creating like" do
      get pod_path

      assert_response :ok

      assert_select "li#comment_#{@comment.id}" do
        assert_select "a.like-action", text: ""
      end

      assert_difference "@comment.likes.count" do
        post comment_like_path(@comment), headers: { "HTTP_REFERER" => pod_path }
      end

      assert_redirected_to pod_path

      follow_redirect!

      assert_select "li#comment_#{@comment.id}" do
        assert_select "a.like-action", text: "1"
      end
    end

    test "creating like with xhr" do
      assert_difference "@comment.likes.count" do
        post comment_like_path(@comment), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "destroying like" do
      @comment.likes.create!(user: @user)

      get pod_path

      assert_response :ok

      assert_select "li#comment_#{@comment.id}" do
        assert_select "a.like-action", text: "1"
      end

      assert_difference "@comment.likes.count", -1 do
        delete comment_like_path(@comment), headers: { "HTTP_REFERER" => pod_path }
      end

      assert_redirected_to pod_path

      follow_redirect!

      assert_select "li#comment_#{@comment.id}" do
        assert_select "a.like-action", text: ""
      end
    end

    test "destroying like with xhr" do
      @comment.likes.create!(user: @user)

      assert_difference "@comment.likes.count", -1 do
        delete comment_like_path(@comment), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end
  end
end
