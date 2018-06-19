require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:bilbo)
    @pod = @user.pods.first
    @comment = Comment.new(commentable: @pod, user: @user, body: "My comment")
  end

  test "is valid" do
    assert @comment.valid?
  end

  test "invalid without commentable" do
    @comment.commentable = nil
    assert_not @comment.valid?
  end

  test "invalid without user" do
    @comment.user = nil
    assert_not @comment.valid?
  end

  test "invalid without body" do
    @comment.body = nil
    assert_not @comment.valid?
  end

  test "invalid if body is too long" do
    @comment.body = "a" * 8001
    assert_not @comment.valid?
  end

  test "squeezeing new lines" do
    @comment.body = "a\n\n\nb\n\n\n\nc\n\nd\n\n\n"
    assert @comment.valid?
    assert_equal @comment.body, "a\n\nb\n\nc\n\nd"
  end
end
