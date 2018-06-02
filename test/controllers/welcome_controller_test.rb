require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should render landing on get index" do
    get root_path
    assert_response :success
    assert_match /Welcome to ReddHub/, @response.body
    assert_select "a[href='#{terms_path}']", text: "Terms"
    assert_select "a[href='#{privacy_path}']", text: "Privacy"
  end

  test "should render user home on get index" do
    sign_in users(:bilbo)
    get root_path
    assert_response :success
    assert_match /Bilbo/, @response.body
    assert_no_match /Welcome to ReddHub/, @response.body
  end
end
