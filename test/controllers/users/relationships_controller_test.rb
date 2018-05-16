require "test_helper"

class Users::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @follower = users(:bilbo)
    @following = users(:thorin)
  end

  class LoggedIn < Users::RelationshipsControllerTest
    def setup
      super
    end

    test "should redirect on create" do
      assert_no_difference "Relationship.count" do
        post user_relationship_path(@following.username)
      end

      assert_redirected_to new_user_session_path
    end

    test "should redirect on destroy" do
      assert_no_difference "Relationship.count" do
        delete user_relationship_path(@following.username)
      end

      assert_redirected_to new_user_session_path
    end

    test "should return unauthorized on create" do
      assert_no_difference "Relationship.count" do
        post user_relationship_path(@following.username), xhr: true
      end

      assert_response :unauthorized
    end

    test "should return unauthorized on destroy" do
      assert_no_difference "Relationship.count" do
        delete user_relationship_path(@following.username), xhr: true
      end

      assert_response :unauthorized
    end
  end

  class LoggedOut < Users::RelationshipsControllerTest
    def setup
      super
      sign_in @follower
    end

    test "should redirect to following on create" do
      assert_difference "Relationship.count" do
        post user_relationship_path(@following.username)
      end

      assert_redirected_to user_path(@following.username)
    end

    test "should redirect to following on delete" do
      @follower.follow(@following)

      assert_difference "Relationship.count", -1 do
        delete user_relationship_path(@following.username)
      end

      assert_redirected_to user_path(@following.username)
    end

    test "should return success on create" do
      assert_difference "Relationship.count" do
        post user_relationship_path(@following.username), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end

    test "should return success on delete" do
      @follower.follow(@following)

      assert_difference "Relationship.count", -1 do
        delete user_relationship_path(@following.username), xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
    end
  end
end
