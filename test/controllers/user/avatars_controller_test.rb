require "test_helper"

class User::AvatarsControllerTest < ActionDispatch::IntegrationTest
  class SignOut < ActionDispatch::IntegrationTest
    test "should get update user avatar" do
      put avatars_path, params: { avatar: fixture_file_upload("files/avatar.png") }

      assert_redirected_to new_user_session_path
    end
  end

  class SignIn < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:eo)
    end

    test "should update user avatar and redirect to edit view" do
      put avatars_path, params: { avatar: fixture_file_upload("files/avatar.png") }

      assert_redirected_to edit_user_registration_path
    end
  end
end
