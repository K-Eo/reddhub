require "test_helper"

class Profiles::ProfileControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "seeing pods" do
    get user_profile_path(@user.username)
    assert_response :success

    assert_select "p", @user.name

    @user.pods.each do |pod|
      assert_select "li.pod" do
        assert_select "p", text: pod.content
      end
    end
  end

  test "can't see pods pending for delete" do
    get user_profile_path(@user.username)

    assert_response :ok

    assert_select "p", @user.name

    assert_select "li.pod", count: 2

    pod = pods(:one)

    pod.mark_as_delete

    get user_profile_path(@user.username)

    assert_response :ok

    assert_select "li.pod", count: 1
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

  test "seeing empty state when user has no pods" do
    get user_profile_path("cassian")

    assert_response :ok

    assert_select "li.pod", count: 0

    assert_select "h3", text: /ZERO PODS/
    assert_select "p", text: /No pods to show at this time/
  end
end
