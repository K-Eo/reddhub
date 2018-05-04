require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  class SignOut < ActionDispatch::IntegrationTest
    setup do
      @story = stories(:one)
    end

    test "should redirect get index" do
      get stories_path
      assert_redirected_to new_user_session_path
    end

    test "should get new" do
      get new_story_url
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

    test "should redirect on preview" do
      post preview_stories_url, params: { content: "Foo bar" }, xhr: true
      assert_response :unauthorized
    end

    test "should redirect on publish" do
      post publish_story_url(@story)
      assert_redirected_to new_user_session_path

      post publish_story_url(@story), xhr: true
      assert_response :unauthorized
    end

    test "should redirect on unpublish" do
      delete unpublish_story_url(@story)
      assert_redirected_to new_user_session_path

      delete unpublish_story_url(@story), xhr: true
      assert_response :unauthorized
    end
  end

  class SignIn < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:eo)
      @story = stories(:one)
    end

    test "should get index" do
      get stories_url
      assert_response :success
    end

    test "should get new" do
      get new_story_url
      assert_redirected_to edit_story_url(Story.last)
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

    test "should get story preview" do
      post preview_stories_url, params: { content: "# Foo bar" }, xhr: true
      assert_response :success
      assert_equal "text/javascript", @response.content_type
      assert_match /Foo bar/, @response.body
    end

    test "should publish a story" do
      post publish_story_url(@story), xhr: true

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "should unpublish a story" do
      delete unpublish_story_url(@story), xhr: true

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end
  end
end
