require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "seeing terms" do
    get terms_path
    assert_response :success
  end

  test "seeing terms as user" do
    sign_in users(:bilbo)
    get terms_path
    assert_response :success
  end

  test "seeing privacy" do
    get privacy_path
    assert_response :success
  end

  test "seeing privacy as user" do
    sign_in users(:bilbo)
    get privacy_path
    assert_response :success
  end

  test "seeing disclaimer" do
    get disclaimer_path
    assert_response :success
  end

  test "seeing disclaimer as user" do
    sign_in users(:bilbo)
    get disclaimer_path
    assert_response :success
  end
end
