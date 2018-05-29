require "test_helper"

class Profiles::ProfileControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "should get show" do
    get user_profile_path(@user.username)
    assert_response :success

    assert_select "p", @user.name

    @user.pods.each do |pod|
      assert_select "li.pod" do
        assert_select "p", text: pod.content
      end
    end
  end

  test "should redirect to 404 if user does not exist" do
    get user_profile_path("foo")
    assert_response :not_found
  end

  test "seeing no reactions when logged out" do
    @user.pods.last.reactions.create(user: @user, name: "rage")

    get user_profile_path(@user.username)

    assert_response :ok

    assert_select "button.btn-action", count: 2 do
      assert_select "i.fa-smile"
    end
  end

  test "seeing reactions when logged in" do
    @user.pods.last.reactions.create(user: @user, name: "rage")
    sign_in(@user)

    get user_profile_path(@user.username)

    assert_response :ok

    assert_select "a.btn-action" do
      assert_select "img[title=':rage:']"
    end
  end

  test "seeing profile with username as any case" do
    get user_profile_path("bilbo")

    assert_response :ok
    assert_select "p", text: @user.name

    get user_profile_path("BILBO")

    assert_response :ok
    assert_select "p", text: @user.name
  end
end
