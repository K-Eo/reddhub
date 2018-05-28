require "test_helper"

class Pods::ReactionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
    @pod = pods(:one)
  end

  class LoggedOut < Pods::ReactionsControllerTest
    def setup
      super
    end

    test "redirect to login on create reaction" do
      assert_no_difference "@pod.reactions.count" do
        post pod_reaction_path(@pod)
      end

      assert_redirected_to new_user_session_path
    end

    test "redirect to login on destroy reaction" do
      assert_no_difference "@pod.reactions.count" do
        delete pod_reaction_path(@pod)
      end

      assert_redirected_to new_user_session_path
    end
  end

  class LoggedIn < Pods::ReactionsControllerTest
    def setup
      super
      sign_in(@user)
    end

    test "creating reaction" do
      get root_path

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "button[data-controller=reactions][data-id='#{@pod.id}']", text: ""
      end

      assert_difference "@pod.reactions.count" do
        post pod_reaction_path(@pod), headers: { "HTTP_REFERER": root_path }
      end

      assert_redirected_to root_path

      follow_redirect!

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a#reaction_#{@pod.id}[data-method=delete][href='/pods/#{@pod.id}/reaction']" do
          assert_select "img[title=':+1:']"
        end
      end
    end

    test "creating reaction with given name" do
      get root_path

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "button[data-controller=reactions][data-id='#{@pod.id}']", text: ""
      end

      assert_difference "@pod.reactions.count" do
        post pod_reaction_path(@pod), params: { name: "rage" }, headers: { "HTTP_REFERER": root_path }
      end

      assert_redirected_to root_path

      follow_redirect!

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a#reaction_#{@pod.id}[data-method=delete][href='/pods/#{@pod.id}/reaction']" do
          assert_select "img[title=':rage:']"
        end
      end
    end

    test "creating reaction with given name not in collection" do
      get root_path

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "button[data-controller=reactions][data-id='#{@pod.id}']", text: ""
      end

      assert_difference "@pod.reactions.count" do
        post pod_reaction_path(@pod), params: { name: "foo" }, headers: { "HTTP_REFERER": root_path }
      end

      assert_redirected_to root_path

      follow_redirect!

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a#reaction_#{@pod.id}[data-method=delete][href='/pods/#{@pod.id}/reaction']" do
          assert_select "img[title=':+1:']"
        end
      end
    end

    test "destroying reaction" do
      @pod.reactions.create!(user: @user, name: "+1")

      get root_path

      assert_response :ok

      assert_select "li#pod_#{@pod.id}" do
        assert_select "a#reaction_#{@pod.id}[data-method=delete][href='/pods/#{@pod.id}/reaction']" do
          assert_select "img[title=':+1:']"
        end
      end

      assert_difference "@pod.reactions.count", -1 do
        delete pod_reaction_path(@pod), headers: { HTTP_REFERER: root_path }
      end

      assert_redirected_to root_path

      follow_redirect!

      assert_select "li#pod_#{@pod.id}" do
        assert_select "button[data-controller=reactions][data-id='#{@pod.id}']", text: ""
      end
    end
  end
end
