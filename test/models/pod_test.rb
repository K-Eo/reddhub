require "test_helper"

class PodTest < ActiveSupport::TestCase
  def setup
    @user = users(:bilbo)
    @pod = Pod.new(user: @user, content: "Foo bar")
  end

  test "is valid" do
    assert @pod.valid?
  end

  test "is invalid without content" do
    @pod.content = nil
    assert_not @pod.valid?
  end

  test "is invalid if content is too long" do
    @pod.content = "a" * 281
    assert_not @pod.valid?
  end

  test "squeezeing new lines" do
    @pod.content = "a\n\n\nb\n\n\n\nc\n\nd\n\n\n"
    assert @pod.valid?
    assert_equal @pod.content, "a\n\nb\n\nc\n\nd"
  end

  test "normalizing new lines" do
    @pod.content = "a\r\n\nb"
    assert @pod.valid?
    assert_equal @pod.content, "a\n\nb"

    @pod.content = "a\r\n\r\n\r\nb\r\nc\r\n\r\n\r\n"
    assert @pod.valid?
    assert_equal @pod.content, "a\n\nb\nc"

    @pod.content = "a\r\n\n\nb"
    assert @pod.valid?
    assert_equal @pod.content, "a\n\nb"
  end

  test "removes space between new lines" do
    @pod.content = "a\n\s\s\n\s\s\nb\s\n\n\n\nc\n\nd\n\n\n"
    assert @pod.valid?
    assert_equal @pod.content, "a\n\nb\n\nc\n\nd"
  end

  test "removes extra spaces" do
    @pod.content = "     abc    "
    assert @pod.valid?
    assert_equal @pod.content, "abc"
  end

  test "is invalid if has no user" do
    @pod.user = nil
    assert_not @pod.valid?
  end
end
