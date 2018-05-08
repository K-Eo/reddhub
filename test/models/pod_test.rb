require "test_helper"

class PodTest < ActiveSupport::TestCase
  def setup
    @user = users(:eo)
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
    @pod.content = "a" * 257
    assert_not @pod.valid?
  end

  test "is invalid if has no user" do
    @pod.user = nil
    assert_not @pod.valid?
  end
end
