require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  class LoggedIn < WelcomeControllerTest
    test "should render landing on get index" do
      get root_path
      assert_response :success
      assert_match /Welcome to ReddHub/, @response.body
    end
  end

  class LoggedOut < WelcomeControllerTest
    test "should render user home on get index" do
      sign_in users(:bilbo)
      get root_path
      assert_response :success
      assert_match /Bilbo/, @response.body
      assert_no_match /Welcome to ReddHub/, @response.body
    end
  end
end
