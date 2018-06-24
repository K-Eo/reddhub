require "test_helper"

class StoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:bilbo)
    @story = Story.new(user: @user, content: "# Foo bar")
  end

  test "is valid" do
    @story.valid?
    assert @story.valid?
  end

  test "invalid without content" do
    @story.content = nil
    assert_not @story.valid?
  end

  test "invalid if not story format" do
    @story.content = "a"
    assert_not @story.valid?

    @story.content = "# My title\n\nMy long long description"
    assert @story.valid?
  end

  test "invalid if too long" do
    @story.content = "# " + "a" * 7999
    assert_not @story.valid?

    @story.content = "# " + "a" * 7998
    assert @story.valid?
  end

  test "extracting title and description" do
    @story.content = "# My title\n\nMy long long description"
    @story.save
    @story.reload

    assert_equal "My title", @story.title
    assert_equal "My long long description", @story.description
  end

  test "update title and description" do
    @story.content = "# My title\n\nMy long long description"
    @story.save
    @story.content = "# My story\n\nMy long long story"
    @story.save
    @story.reload

    assert_equal "My story", @story.title
    assert_equal "My long long story", @story.description
  end

  test "extract first 100 chars for title" do
    title = "a" * 101
    @story.content = "# #{title}\n\nMy long long description"
    @story.save
    @story.reload

    assert_equal 100, @story.title.length

    title = "a" * 99
    @story.content = "# #{title}\n\nMy long long description"
    @story.save
    @story.reload

    assert_equal 99, @story.title.length
  end

  test "extract first 150 chars for description" do
    description = "a" * 151
    @story.content = "# My title\n\n#{description}"
    @story.save
    @story.reload

    assert_equal 150, @story.description.length

    description = "a" * 149
    @story.content = "# My title\n\n#{description}"
    @story.save
    @story.reload

    assert_equal 149, @story.description.length
  end

  test "is story" do
    content = "# My title\n\nMy description"
    assert Story.story?(content)

    content = "# My title\n\n# My description"
    assert Story.story?(content)

    content = "My title\n\nMy description"
    assert_not Story.story?(content)

    content = "#  My title\n\nMy description"
    assert_not Story.story?(content)

    content = "#My title\n\nMy description"
    assert_not Story.story?(content)

    content = " # My title\n\nMy description"
    assert_not Story.story?(content)

    content = "## My title\n\nMy description"
    assert_not Story.story?(content)

    content = "  My title\n\nMy description"
    assert_not Story.story?(content)
  end

  test "parses content to markdown on save" do
    @story.content = "# My title\n\nMy description\n\nMy content\n\nMore content"
    @story.save
    @story.reload

    assert_equal "<p>My content</p>\n\n<p>More content</p>\n", @story.content_html
  end
end
