require "test_helper"

class StoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:eo)
    @story = Story.new(title: "Foo Bar", content: "Foo Baz", user: @user)
  end

  test "valid story" do
    assert @story.valid?
  end

  test "invalid without title" do
    @story.title = nil
    assert_not @story.valid?(:with_meta)
  end

  test "invalid if title length is greater than 60 characters" do
    @story.title = "a" * 61
    assert_not @story.valid?(:with_meta)
  end

  test "invalid without content" do
    @story.content = nil
    assert_not @story.valid?(:with_content)
  end

  class StoryState < StoryTest
    test "draft as initial state" do
      @story.save
      assert_equal "draft", @story.state
    end

    test "publish sets state to published" do
      @story.save
      assert_changes -> { @story.state }, from: "draft", to: "public" do
        @story.publish
      end
    end

    test "sets published_at when changing to published state" do
      @story.save
      assert_changes -> { @story.published_at }, "Expected published_at to not be nil" do
        @story.publish
      end
    end

    test "sets published_at to nil when changing to draft state" do
      @story.save
      @story.publish
      assert_changes -> { @story.published_at }, "Expected published_at to be nil" do
        @story.unpublish
      end
      assert_not @story.published_at
    end

    test "unpublish sets state to draft" do
      @story.save
      @story.publish
      assert_changes -> { @story.state }, from: "public", to: "draft" do
        @story.unpublish
      end
    end
  end
end
