require "test_helper"

class Pods::ReactionsControllerTest < ActionDispatch::IntegrationTest
  test "creating reaction" do
    username = users(:bilbo).username
    user = users(:marty)
    pod = pods(:one)
    sign_in(user)

    get user_profile_path(username)

    assert_response :ok

    assert_select "li#pod_#{pod.id}" do
      assert_select "div[data-controller=reactions][data-reactions-id='#{pod.id}']", text: ""
      assert_select "span.action-count", count: 0
    end

    assert_difference "pod.reactions.count" do
      post pod_reaction_path(pod, name: "rage"), headers: { "HTTP_REFERER": user_profile_path(username) }
    end

    assert_redirected_to user_profile_path(username)

    follow_redirect!

    assert_select "li#pod_#{pod.id}" do
      assert_select "a#reaction_#{user.reactions.last.id}[data-method=delete][href='/pods/#{pod.id}/reaction']" do
        assert_select "img[title=':rage:']"
        assert_select "span.action-count", text: "1"
      end
    end
  end

  test "destroying reaction" do
    owner = users(:thorin)
    sign_in(owner)
    pod = pods(:with_reactions)
    user = users(:bilbo)
    reaction = reactions(:rage)

    get user_profile_path(user.username)

    assert_response :ok

    assert_select "li#pod_#{pod.id}" do
      assert_select "a#reaction_#{reaction.id}[data-method=delete][href='/pods/#{pod.id}/reaction']" do
        assert_select "img[title=':rage:']"
        assert_select "span.action-count", text: "1"
      end
    end

    assert_difference "pod.reactions.count", -1 do
      delete pod_reaction_path(pod), headers: { HTTP_REFERER: user_profile_path(user.username) }
    end

    assert_redirected_to user_profile_path(user.username)

    follow_redirect!

    assert_select "li#pod_#{pod.id}" do
      assert_select "div[data-controller=reactions][data-reactions-id='#{pod.id}']"
      assert_select "span.action-count", count: 0
    end
  end

  test "redirect to login on create reaction" do
    username = users(:bilbo).username
    user = users(:marty)
    pod = pods(:one)

    get user_profile_path(username)

    assert_response :ok

    assert_select "li#pod_#{pod.id}" do
      assert_select "div[data-controller=reactions][data-reactions-id='#{pod.id}']", text: ""
    end

    assert_no_difference "pod.reactions.count" do
      post pod_reaction_path(pod, name: "rage"), headers: { "HTTP_REFERER": user_profile_path(username) }
    end

    assert_redirected_to new_user_session_path
  end

  test "redirect to login on destroy reaction" do
    pod = pods(:with_reactions)
    user = users(:bilbo)
    reaction = reactions(:rage)

    get user_profile_path(user.username)

    assert_response :ok

    assert_select "li#pod_#{pod.id}" do
      assert_select "div[data-controller=reactions][data-reactions-id='#{pod.id}']", text: "1"
    end

    assert_no_difference "pod.reactions.count" do
      delete pod_reaction_path(pod), headers: { HTTP_REFERER: user_profile_path(user.username) }
    end

    assert_redirected_to new_user_session_path
  end
end
