require "test_helper"

class Finders::UsersControllerTest < ActionDispatch::IntegrationTest
  test "finding user" do
    sign_in users(:bilbo)

    get root_path

    assert_response :ok

    assert_select "form[action='#{finder_users_path}']" do
      assert_select "input[type=text][name=q][placeholder='Find users']"
    end

    get finder_users_path, params: { q: "i" }

    assert_response :ok

    assert_select "a.h2", text: "users finder"

    assert_select "div.user", count: 3

    assert_select "a", text: "@Thorin"
    assert_select "a", text: "@cassian"
    assert_select "a", text: "@Bilbo"
  end

  test "sanitizes %" do
    sign_in users(:bilbo)

    get finder_users_path, params: { q: "%" }

    assert_response :ok

    assert_select "a.h2", text: "users finder"

    assert_select "div.user", count: 0
    assert_select "h3", "NO RESULTS"
  end

  test "returns no results if q is empty" do
    sign_in users(:bilbo)

    get finder_users_path, params: { q: "" }

    assert_response :ok

    assert_select "a.h2", text: "users finder"

    assert_select "div.user", count: 0
    assert_select "h3", "FIND PEOPLE"
  end

  test "returns empty state if q is not present" do
    sign_in users(:bilbo)

    get finder_users_path

    assert_response :ok

    assert_select "a.h2", text: "users finder"

    assert_select "div.user", count: 0
    assert_select "h3", "FIND PEOPLE"
  end

  test "return empty state if no results" do
    sign_in users(:bilbo)

    get finder_users_path, params: { q: "x" }

    assert_response :ok

    assert_select "a.h2", text: "users finder"

    assert_select "div.user", count: 0
    assert_select "h3", "NO RESULTS"
  end

  test "can't find if user is guest" do
    get root_path

    assert_response :ok

    assert_select "form[action='#{finder_users_path}']", count: 0

    get finder_users_path, params: { q: "i" }

    assert_redirected_to new_user_session_path
  end
end
