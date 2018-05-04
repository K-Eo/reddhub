require "test_helper"

class StoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:eo)
    @story = Story.new(
      title: "",
      subtitle: "",
      content: "",
      user: @user
    )
  end

  test "valid story" do
    assert @story.valid?
  end

  class OnUpdate < StoryTest
    def setup
      super
      @story.title = "Title"
      @story.subtitle = "Subtitle"
      @story.content = "# Content"
      @story.save
    end

    test "invalid without title" do
      @story.title = nil
      assert_not @story.valid?
    end

    test "invalid if title length is greater than 60 characters" do
      @story.title = "a" * 61
      assert_not @story.valid?
    end

    test "invalid without subtitle" do
      @story.subtitle = nil
      assert_not @story.valid?
    end

    test "invalid if subtitle is greated than 120 characters" do
      @story.subtitle = "a" * 121
      assert_not @story.valid?
    end

    test "invalid without content" do
      @story.content = nil
      assert_not @story.valid?
    end
  end

  class StoryState < OnUpdate
    def setup
      super
    end

    test "returns true if state is public" do
      @story.publish
      assert @story.public?
      assert_not @story.draft?
    end

    test "returns true if state is draft" do
      assert @story.draft?
      assert_not @story.public?
    end

    test "draft as initial state" do
      assert_equal "draft", @story.state
    end

    test "publish sets state to published" do
      assert_changes -> { @story.state }, from: "draft", to: "public" do
        @story.publish
      end
    end

    test "sets published_at when changing to published state" do
      assert_changes -> { @story.published_at }, "Expected published_at to not be nil" do
        @story.publish
      end
    end

    test "sets published_at to nil when changing to draft state" do
      @story.publish
      assert_changes -> { @story.published_at }, "Expected published_at to be nil" do
        @story.unpublish
      end
      assert_not @story.published_at
    end

    test "unpublish sets state to draft" do
      @story.publish
      assert_changes -> { @story.state }, from: "public", to: "draft" do
        @story.unpublish
      end
    end
  end
end
