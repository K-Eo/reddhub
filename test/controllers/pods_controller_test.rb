require "test_helper"

class PodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "creating pod" do
    sign_in @user

    get root_path

    assert_response :ok

    assert_select "li.pod", count: 2
    assert_select "form#new_pod" do
      assert_select "textarea#pod_content"
      assert_select "input[type=submit][value='Create Pod']"
    end

    assert_difference "@user.pods.count" do
      post pods_path, params: { pod: { content: "Foo bar"  } }
    end

    assert_redirected_to root_path

    follow_redirect!

    assert_select "li.pod", count: 3
    assert_select "li.pod" do
      assert_select "p", text: "Foo bar"
    end

    assert_equal @user, Pod.last.user
    assert_select "div", text: /Pod was successfully created/
  end

  test "creating pod with error" do
    sign_in @user

    get root_path

    assert_response :ok

    assert_no_difference "@user.pods.count" do
      post pods_path, params: { pod: { content: ""  } }
    end

    assert_response :success

    assert_select "li.pod", count: 2
    assert_select "div", text: /can't be blank/

    assert_no_difference "@user.pods.count" do
      post pods_path, params: { pod: { content: ("a" * 281) } }
    end

    assert_response :success

    assert_select "li.pod", count: 2
    assert_select "div", text: /is too long/
    assert_select "div", text: /Pod can't be created/
  end

  test "seeing reactions if pod has errors" do
    sign_in @user
    @user.pods.first.reactions.create(user: @user, name: "rage")
    @user.pods.last.reactions.create(user: @user, name: "+1")

    get root_path

    assert_response :ok

    assert_select "li.pod", count: 2
    assert_select "img[title=':rage:']"
    assert_select "img[title=':+1:']"

    assert_no_difference "@user.pods.count" do
      post pods_path, params: { pod: { content: "" } }
    end

    assert_response :ok
    assert_select "div", text: /can't be blank/
    assert_select "li.pod", count: 2
    assert_select "img[title=':rage:']"
    assert_select "img[title=':+1:']"
  end

  test "redirects to login on creating pod" do
    post pods_path, params: { pod: { content: "Foo bar"  } }

    assert_redirected_to new_user_session_path
  end

  test "destroying" do
    pod = pods(:one)
    sign_in @user

    get root_path

    assert_response :ok

    assert_select "li.pod", count: 2

    assert_select "div.action" do
      assert_select "a[data-method=delete][href='#{pod_path(pod)}']"
    end

    get user_pod_path(@user.username, pod)

    assert_select "div.action" do
      assert_select "a[data-method=delete][href='#{pod_path(pod)}']"
    end

    assert_enqueued_with(job: DestroyPodJob) do
      delete pod_path(pod)
    end

    assert_redirected_to root_path
    follow_redirect!

    assert_select "li.pod", count: 1
    assert_select "div", /Pod was successfully deleted/
  end

  test "redirects to login on destroying" do
    pod = pods(:one)

    delete pod_path(pod)

    assert_redirected_to new_user_session_path
  end
end
