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
    @pod.content = "a" * 280
    assert @pod.valid?

    @pod.content = "a" * 281
    assert_not @pod.valid?
  end

  test "sanitizes content" do
    @pod.content = "a\n\n\nb\n\n\n\nc\s\s\s\n\nd\n\n\n"
    assert @pod.valid?
    assert_equal "a\n\nb\n\nc\n\nd", @pod.content
  end

  test "is invalid if has no user" do
    @pod.user = nil
    assert_not @pod.valid?
  end

  test "destroying" do
    pod = pods(:one)

    assert_not pod.pending_delete
    assert_enqueued_with(job: DestroyPodJob) do
      pod.purge
    end

    pod.reload
    assert pod.pending_delete
  end
end
