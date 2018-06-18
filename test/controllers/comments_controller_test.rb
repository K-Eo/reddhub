require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comment = comments(:with_reactions)
  end

  test "destroying comment" do
    pod = @comment.commentable
    user = pod.user

    sign_in @comment.user

    get user_pod_path(user.username, pod)

    assert_response :ok

    assert_select "li#comment_#{@comment.id}"
    assert_select "a[href='/comments/#{@comment.id}'][data-method=delete]"

    assert_difference ["pod.comments.count", "Reaction.count"], -1 do
      delete comment_path(@comment)
    end

    assert_redirected_to user_pod_path(user.username, pod)

    follow_redirect!

    assert_select "li#comment_#{@comment.id}", count: 0
    assert_select "a[href='/comments/#{@comment.id}'][data-method=delete]", count: 0

    assert_select "div", /Your comment was successfully deleted/
  end

  test "only author can destroy his comment" do
    pod = @comment.commentable
    user = pod.user

    sign_in users(:cassian)

    get user_pod_path(user.username, pod)

    assert_response :ok

    assert_select "li#comment_#{@comment.id}"
    assert_select "a[href='/comments/#{@comment.id}'][data-method=delete]", count: 0

    assert_no_difference ["pod.comments.count", "Reaction.count"] do
      delete comment_path(@comment)
    end

    assert_redirected_to user_pod_path(user.username, pod)

    follow_redirect!

    assert_select "div", /You can delete comments from other users/
  end

  test "redirects to login" do
    delete comment_path(@comment)

    assert_redirected_to new_user_session_path
  end
end
