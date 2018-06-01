require "test_helper"

class Profiles::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "redirects to login on create" do
    followed = users(:thorin)

    assert_no_difference ["Relationship.count", "followed.followers.count"] do
      post user_relationship_path(followed.username)
    end

    assert_redirected_to new_user_session_path
  end

  test "redirects to login on destroy" do
    followed = users(:bilbo)

    assert_no_difference ["Relationship.count", "followed.followers.count"] do
      delete user_relationship_path(followed.username)
    end

    assert_redirected_to new_user_session_path
  end

  test "following user" do
    follower = users(:bilbo)
    followed = users(:thorin)
    sign_in(follower)

    get user_profile_path(followed.username)

    assert_response :ok

    assert_select "div#user_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=post]", text: "Follow"
    end

    assert_difference ["Relationship.count", "follower.following.count", "followed.followers.count"] do
      post user_relationship_path(followed.username)
    end

    assert_redirected_to user_profile_path(followed.username)

    follow_redirect!

    assert_select "div#user_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=delete]", text: "Unfollow"
    end

    assert_select "div", text: /You are following @#{followed.username} now/
  end

  test "following user from following list" do
    follower = users(:bilbo)
    profile = users(:marty)
    followed = users(:thorin)

    sign_in(follower)

    get user_following_path(profile.username)

    assert_response :ok

    assert_select "div#user_card_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=post]", text: "Follow"
    end

    assert_difference ["Relationship.count", "follower.following.count", "followed.followers.count"] do
      post user_relationship_path(followed.username)
    end

    assert_redirected_to user_profile_path(followed.username)

    follow_redirect!

    assert_select "div#user_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=delete]", text: "Unfollow"
    end

    assert_select "div", text: /You are following @#{followed.username} now/
  end

  test "unfollowing user" do
    follower = users(:marty)
    followed = users(:thorin)
    sign_in(follower)

    get user_profile_path(followed.username)

    assert_response :ok

    assert_select "div#user_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=delete]", text: "Unfollow"
    end

    assert_difference ["Relationship.count", "follower.following.count", "followed.followers.count"], -1 do
      delete user_relationship_path(followed.username)
    end

    assert_redirected_to user_profile_path(followed.username)

    follow_redirect!

    assert_select "div#user_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=post]", text: "Follow"
    end

    assert_select "div", text: /You have stopped following @#{followed.username}/
  end

  test "unfollowing user from following list" do
    follower = users(:marty)
    profile = users(:doc)
    followed = users(:thorin)

    sign_in(follower)

    get user_following_path(profile.username)

    assert_response :ok

    assert_select "div#user_card_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=delete]", text: "Unfollow"
    end

    assert_difference ["Relationship.count", "follower.following.count", "followed.followers.count"], -1 do
      delete user_relationship_path(followed.username)
    end

    assert_redirected_to user_profile_path(followed.username)

    follow_redirect!

    assert_select "div#user_#{followed.id}" do
      assert_select "p", text: followed.name
      assert_select "a[data-method=post]", text: "Follow"
    end

    assert_select "div", text: /You have stopped following @#{followed.username}/
  end
end
