require "test_helper"

class Profiles::ProfileControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "should get show" do
    get user_profile_path(@user.username)
    assert_response :success

    assert_select "p", @user.name
  end

  test "should redirect to 404 if user does not exist" do
    get user_profile_path("foo")
    assert_response :not_found
  end
end
