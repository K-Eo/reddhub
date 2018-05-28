require "test_helper"

class Pods::CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
    @pod = @user.pods.first
  end

  class LoggedOut < Pods::CommentsControllerTest
    def setup
      super
    end

    test "redirect to login on create comment" do
      post pod_comments_path(@pod), params: { comment: { body: "My comment" } }

      assert_redirected_to new_user_session_path
    end
  end

  class LoggedIn < Pods::CommentsControllerTest
    def setup
      super
      sign_in @user
    end

    test "creating comment on pod" do
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "form#new_comment" do
        assert_select "textarea#comment_body", text: ""
        assert_select "input[type=submit][value='Reply']"
      end

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 0
      end

      assert_difference "@pod.comments.count" do
        post pod_comments_path(@pod), params: { comment: { body: "My comment" } }
      end

      assert_redirected_to user_pod_path(@user.username, @pod)

      follow_redirect!

      assert_select "form#new_comment" do
        assert_select "textarea#comment_body", text: ""
        assert_select "input[type=submit][value='Reply']"
      end

      comment = @pod.comments.last
      assert_equal @user, comment.user

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 1
        assert_select "li#comment_#{comment.id}" do
          assert_select "a", text: "#{@user.name} @#{@user.username}"
          assert_select "p", text: comment.body
        end
      end

      assert_select "div", text: /Your comment was successfully created/
    end

    test "creating comment on pod with error" do
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "form#new_comment" do
        assert_select "textarea#comment_body", text: ""
        assert_select "input[type=submit][value='Reply']"
      end

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 0
      end

      assert_no_difference "@pod.comments.count" do
        post pod_comments_path(@pod), params: { comment: { body: "" } }
      end

      assert_response :ok

      assert_select "form#new_comment" do
        assert_select "textarea#comment_body", text: ""
        assert_select "div", text: "can't be blank"
        assert_select "input[type=submit][value='Reply']"
      end

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 0
      end
    end

    test "show comments pagination" do
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 0
      end

      assert_select "nav.pagination", count: 0

      26.times.each do |i|
        @pod.comments.create!(user: @user, body: "Comment #{i}")
      end

      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 20
      end

      assert_select "ul.pagination" do
        assert_select "li.active", text: "1"
        assert_select "li", text: "2"
      end

      get user_pod_path(@user.username, @pod, page: 2)

      assert_response :ok

      assert_select "ul#pod_comments_#{@pod.id}" do
        assert_select "li.comment", count: 6
      end

      assert_select "ul.pagination" do
        assert_select "li", text: "1"
        assert_select "li.active", text: "2"
      end
    end

    test "incrementing comments counter" do
      get user_profile_path(@user.username)

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a.btn-action[href*='#pod_comments_#{@pod.id}']", text: ""
      end

      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "div.actions" do
        assert_select "a.btn-action", text: ""
      end

      post pod_comments_path(@pod), params: { comment: { body: "My Comment" } }

      follow_redirect!

      assert_select "div.actions" do
        assert_select "a.btn-action", text: "1"
      end

      get user_profile_path(@user.username)

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a.btn-action", text: "1"
      end
    end
  end
end
