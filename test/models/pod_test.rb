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

  test "saving as pod" do
    @pod.save
    assert_equal 0, @pod.kind
    assert @pod.pod?
    assert_not @pod.story?
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

  test "saving as story" do
    @pod.content = "# My title\n\nMy long long description\n\nFoo"
    assert @pod.valid?
    @pod.save
    assert_equal 1, @pod.kind
    assert @pod.story?
    assert_not @pod.pod?
  end

  test "too long when is story" do
    @pod.content = "# My title\n\nMy long long description\n\nFoo" + "a" * 7960
    assert_not @pod.valid?

    @pod.content = "# My title\n\nMy long long description\n\nFoo" + "a" * 7959
    assert @pod.valid?
  end

  test "extracting title and description for story" do
    @pod.content = "# My title\n\nMy long description\n\nMy content"
    @pod.save

    assert_equal "My title", @pod.title
    assert_equal "My long description", @pod.description
  end

  test "updating title and description for story" do
    @pod.content = "# My title\n\nMy long description\n\nMy content"
    @pod.save

    @pod.content = "# Foo\n\nBar\n\nBaz"
    @pod.save

    assert_equal "Foo", @pod.title
    assert_equal "Bar", @pod.description
  end

  test "parses story body to markdown" do
    @pod.content = "# Foo\n\nBar\n\nBaz\n\nFoo"
    @pod.save

    assert_equal "<p>Baz</p>\n\n<p>Foo</p>\n", @pod.content_html
  end
end
