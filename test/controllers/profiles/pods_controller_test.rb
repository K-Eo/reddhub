require "test_helper"

class Profiles::PodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
    @pod = @user.pods.first
  end

  class LoggedOut < Profiles::PodsControllerTest
    def setup
      super
    end

    test "seeing pod" do
      get user_profile_path(@user.username)

      assert_response :ok

      assert_select "p", text: @pod.content
      assert_select ".pod", count: 2

      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select ".pod", count: 0
      assert_select ".card" do
        assert_select "a[href='/#{@user.username}']" do
          assert_select "p", text: @user.name
          assert_select "p", text: "@#{@user.username}"
        end

        assert_select "p", text: @pod.content
      end
    end

    test "comment form hidden" do
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "form#new_comment", count: 0
    end

    test "hidden reaction" do
      @pod.reactions.create(user: @user, name: "+1")

      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "button[data-controller=reactions][data-id='#{@pod.id}']"
    end
  end

  class LoggedIn < Profiles::PodsControllerTest
    def setup
      super
      sign_in(@user)
    end

    test "comment form visible" do
      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "form#new_comment"
    end

    test "seeing reaction" do
      @pod.reactions.create(user: @user, name: "+1")

      get user_pod_path(@user.username, @pod)

      assert_response :ok

      assert_select "a#reaction_#{@pod.id}[data-method=delete][href='/pods/#{@pod.id}/reaction']" do
        assert_select "img[title=':+1:']"
      end
    end
  end
end
