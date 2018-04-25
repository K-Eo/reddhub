require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  class SignOut < ActionDispatch::IntegrationTest
    setup do
      @story = stories(:one)
    end

    test "should get new" do
      get new_story_url
      assert_redirected_to new_user_session_path
    end

    test "should create story" do
      assert_no_difference("Story.count") do
        post stories_url, params: { story: { content: @story.content, title: @story.title } }
      end

      assert_redirected_to new_user_session_path
    end

    test "should show story" do
      get story_url(@story)
      assert_response :success
    end

    test "should get edit" do
      get edit_story_url(@story)
      assert_redirected_to new_user_session_path
    end

    test "should destroy story" do
      assert_no_difference("Story.count") do
        delete story_url(@story)
      end

      assert_redirected_to new_user_session_path
    end

    test "should redirect on update content" do
      put content_story_path(@story)

      assert_redirected_to new_user_session_path
    end

    test "should redirect on update meta" do
      put meta_story_path(@story)

      assert_redirected_to new_user_session_path
    end
  end

  class SignIn < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:eo)
      @story = stories(:one)
    end

    test "should get new" do
      get new_story_url
      assert_response :success
    end

    test "should create story" do
      assert_difference("Story.count") do
        post stories_url, params: { story: { content: @story.content, title: @story.title } }
      end

      assert_redirected_to story_url(Story.last)
    end

    test "should show story" do
      get story_url(@story)
      assert_response :success
    end

    test "should get edit" do
      get edit_story_url(@story)
      assert_response :success
    end

    test "should destroy story" do
      assert_difference("Story.count", -1) do
        delete story_url(@story)
      end

      assert_redirected_to root_url
    end

    test "should update story content" do
      put content_story_path(@story), params: { story: { content: "foo bar" } }, xhr: true
      assert_response :success
      @story.reload
      assert_equal "foo bar", @story.content
      assert_match /foo bar/, @response.body
      assert_equal "application/json", @response.content_type
    end

    test "should update story meta" do
      put meta_story_path(@story), params: { story: { title: "Foo bar" } }, xhr: true
      assert_response :success
      @story.reload
      assert_equal "Foo bar", @story.title
      assert_equal "text/javascript", @response.content_type
    end
  end
end
