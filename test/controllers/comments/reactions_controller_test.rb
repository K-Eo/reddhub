require "test_helper"

class Comments::ReactionsControllerTest < ActionDispatch::IntegrationTest
  test "creating reaction" do
    @owner = users(:thorin)
    sign_in(@owner)
    @comment = comments(:welcome)
    @pod = @comment.commentable
    @user = @pod.user

    get user_pod_path(@user.username, @pod)

    assert_response :ok

    assert_select "li#comment_#{@comment.id}" do
      assert_select "div[data-controller=reactions]"
      assert_select "span.action-count", count: 0
    end

    assert_difference "@comment.reactions.count" do
      post comment_reaction_path(@comment),
        headers: { HTTP_REFERER: user_pod_path(@user.username, @pod) }
    end

    assert_redirected_to user_pod_path(@user.username, @pod)

    follow_redirect!

    assert_select "li#comment_#{@comment.id}" do
      assert_select "a#reaction_#{@owner.reactions.last.id}[data-method=delete][href='/comments/#{@comment.id}/reaction']" do
        assert_select "img[title=':+1:']"
        assert_select "span.action-count", text: "1"
      end
    end
  end

  test "destroying reaction" do
    @owner = users(:thorin)
    sign_in(@owner)
    @comment = comments(:with_reactions)
    @pod = @comment.commentable
    @user = @pod.user
    @reactions = reactions(:plus_one)

    get user_pod_path(@user.username, @pod)

    assert_response :ok

    assert_select "li#comment_#{@comment.id}" do
      assert_select "a#reaction_#{@reactions.id}"
      assert_select "img[title=':+1:']"
      assert_select "span.action-count", text: "1"
    end

    assert_difference "@comment.reactions.count", -1 do
      delete comment_reaction_path(@comment),
        headers: { HTTP_REFERER: user_pod_path(@user.username, @pod) }
    end

    assert_redirected_to user_pod_path(@user.username, @pod)

    follow_redirect!

    assert_select "li#comment_#{@comment.id}" do
      assert_select "div[data-controller=reactions]"
      assert_select "span.action-count", count: 0
    end
  end

  test "creating reaction redirects to login" do
    @comment = comments(:welcome)
    @pod = @comment.commentable
    @user = @pod.user
    get user_pod_path(@user.username, @pod)

    assert_response :ok

    assert_no_difference "@comment.reactions.count" do
      post comment_reaction_path(@comment)
    end

    assert_redirected_to new_user_session_path
  end

  test "destroying reaction redirects to login" do
    @comment = comments(:with_reactions)
    @pod = @comment.commentable
    @user = @pod.user
    get user_pod_path(@user.username, @pod)

    assert_response :ok

    assert_no_difference "@comment.reactions.count" do
      delete comment_reaction_path(@comment)
    end

    assert_redirected_to new_user_session_path
  end
end
