require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:bilbo)
  end

  test "render landing page" do
    get root_path
    assert_response :success

    assert_select "h1", text: "Welcome to ReddHub"
  end

  test "render user card" do
    sign_in(@user)
    get root_path
    assert_response :success

    assert_select "img[src*=gravatar]"
    assert_select "p", text: "Bilbo Baggins"
    assert_select "p", text: "@Bilbo"
    assert_select "div", text: "Followers"
    assert_select "div", text: "0"
    assert_select "div", text: "Following"
    assert_select "div", text: "0"
  end

  test "navigate to user profile" do
    sign_in(@user)
    @user.pods.create(content: "My Pod")
    get root_path

    assert_response :success
    assert_select "a", text: "@Bilbo"

    get user_profile_path(@user.username)

    assert_response :success

    assert_select "a.nav-item.active", text: "Pods1"
    assert_select "a.nav-item", text: "Following0"
    assert_select "a.nav-item", text: "Followers0"
  end

  test "render pods" do
    sign_in(@user)
    get root_path

    assert_response :success

    assert_select "a", text: "Bilbo Baggins@Bilbo", count: 2
    assert_select "p", text: "First pod"
    assert_select "p", text: "Second pod"

    assert_select "h6", text: "Thorin", count: 0
    assert_select "h6", text: "Marty", count: 0
    assert_select "h6", text: "Emmett", count: 0
  end

  test "seeing empty state" do
    sign_in(users(:cassian))
    get root_path

    assert_response :success

    assert_select "li.pod", count: 0

    assert_select "h3", text: /EMPTY HOME/
    assert_select "p", text: /Pods from people you follow and your own pods will be shown here/
  end

  test "seeing followers" do
    sign_in(@user)
    @marty = users(:marty)
    @marty.follow(@user)

    get root_path

    assert_response :ok
    assert_select "a[href='/#{@user.username}/followers']", text: "Followers1"

    get user_followers_path(@user.username)

    assert_response :ok

    assert_select "a.nav-item.active", text: "Followers1"

    assert_select "div[id=user_card_#{@marty.id}]" do
      assert_select "p", text: /Marty Mcfly/
      assert_select "a", text: "Following1"
      assert_select "a", text: "Followers0"
      assert_select "a[href='/#{@marty.username}/relationship'][data-method=post]", text: "Follow"
    end
  end

  test "seeing following" do
    sign_in(@user)
    @marty = users(:marty)
    @user.follow(@marty)
    @user.reload

    get root_path

    assert_response :ok
    assert_select "a[href='/#{@user.username}/following']", text: "Following1"

    get user_following_path(@user.username)

    assert_response :ok

    assert_select "a.nav-item.active", text: "Following1"

    assert_select "div[id=user_card_#{@marty.id}]" do
      assert_select "p", text: /Marty Mcfly/
      assert_select "a", text: "Following0"
      assert_select "a", text: "Followers1"
      assert_select "a[href='/#{@marty.username}/relationship'][data-method=delete]", text: "Unfollow"
    end
  end

  test "seeing user profile" do
    sign_in(@user)
    @marty = users(:marty)
    @user.follow(@marty)
    @user.reload

    get user_following_path(@user.username)

    assert_response :ok
    assert_select "a.nav-item.active", text: "Following1"

    assert_select "div[id=user_card_#{@marty.id}]" do
      assert_select "p", text: "Marty Mcfly"
      assert_select "a[href='/#{@marty.username}']", text: "@#{@marty.username}"
    end

    get user_profile_path(@marty.username)

    assert_response :ok

    assert_select "p", text: @marty.name
    assert_select "a", text: "@#{@marty.username}"
    assert_select "a", text: "Followers1"
  end

  test "renders pagination" do
    sign_in(@user)

    get root_path
    assert_response :ok
    assert_select "ul.pagination", count: 0

    30.times.each do |i|
      @user.pods.create!(content: "Pod #{i}")
    end

    get root_path
    assert_response :ok
    assert_select "ul.pagination"
  end
end
