require "test_helper"

class Me::AvatarsControllerTest < ActionDispatch::IntegrationTest
  class LoggedOut < Me::AvatarsControllerTest
    test "redirect to login when create avatar" do
      post me_avatar_path, params: { avatar: { image: nil } }

      assert_redirected_to new_user_session_path
    end

    test "redirect to login when nagivate to edit" do
      get edit_me_avatar_path

      assert_redirected_to new_user_session_path
    end

    test "redirect to login when update avatar" do
      put me_avatar_path, params: { avatar: { image: nil } }

      assert_redirected_to new_user_session_path
    end
  end

  class LoggedIn < Me::AvatarsControllerTest
    setup do
      @user = users(:bilbo)
      sign_in @user
    end

    test "upload new original avatar" do
      get edit_user_registration_path
      assert :ok

      assert_select "img[src*=gravatar]"

      post me_avatar_path, params: { avatar: { image: fixture_file_upload("files/avatar_original.png") } }

      follow_redirect!

      assert_select "img[src*='avatar_original.png']"
      assert_select "img[data-filename='avatar_original.png']"
      assert_select "button[data-action='cropper#save']", text: "Save"
    end

    test "cropp original avatar" do
      @user.original.attach(fixture_file_upload("files/avatar_original.png"))

      get edit_user_registration_path
      assert :ok

      assert_select "a", text: "Resize"

      get edit_me_avatar_path

      assert :ok
      assert_select "img[src*='avatar_original.png']"
      assert_select "img[data-filename='avatar_original.png']"
      assert_select "button[data-action='cropper#save']", text: "Save"
    end

    test "save cropped avatar" do
      @user.original.attach(fixture_file_upload("files/avatar_original.png"))

      get edit_me_avatar_path

      assert :ok

      put me_avatar_path, params: { avatar: { image: fixture_file_upload("files/avatar.png") } }

      follow_redirect!

      assert_select "img[src*='avatar.png']"
      assert_select "a", "Resize"
    end

    test "redirect to edit user if has no original avatar" do
      get edit_me_avatar_path

      assert_redirected_to edit_user_registration_path

      follow_redirect!

      assert_select "div", text: /Upload an avatar first/
    end
  end
end
