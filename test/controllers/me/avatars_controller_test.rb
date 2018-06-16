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

    test "uploading new original avatar" do
      get edit_user_registration_path
      assert :ok

      assert_select "img[src*=gravatar]"

      post me_avatar_path, params: { avatar: { image: fixture_file_upload("files/avatar_original.png") } }

      follow_redirect!

      assert_select "img[src*='avatar_original.png']"
      assert_select "div[data-controller=cropper][data-cropper-filename='avatar_original.png']"
      assert_select "button[data-action='cropper#save']", text: "Save"
      assert_select "div.alert", text: /You have successfully uploaded your avatar. Now you can cropped below\./
    end

    test "renders message if original avatar upload has failed" do
      get edit_user_registration_path
      assert :ok

      assert_select "img[src*=gravatar]"

      post me_avatar_path, params: { avatar: { image: nil } }

      follow_redirect!

      assert_select "img[src*=gravatar]"
      assert_select "div", text: /Snaps! Something went wrong, try again\./
    end

    test "cropping original avatar" do
      @user.original.attach(fixture_file_upload("files/avatar_original.png"))

      get edit_user_registration_path
      assert :ok

      assert_select "a", text: "Resize"

      get edit_me_avatar_path

      assert :ok
      assert_select "img[src*='avatar_original.png']"
      assert_select "div[data-controller=cropper][data-cropper-filename='avatar_original.png']"
      assert_select "button[data-action='cropper#save']", text: "Save"
    end

    test "saving cropped avatar" do
      @user.original.attach(fixture_file_upload("files/avatar_original.png"))

      get edit_me_avatar_path

      assert :ok

      put me_avatar_path, params: { avatar: { image: fixture_file_upload("files/avatar.png") } }

      follow_redirect!

      assert_select "img[src*='avatar.png']"
      assert_select "a", "Resize"
      assert_select "div", test: /Avatar has been saved\./
    end

    test "renders a message if saving the cropped image has failed" do
      @user.original.attach(fixture_file_upload("files/avatar_original.png"))

      get edit_me_avatar_path

      assert :ok

      put me_avatar_path, params: { avatar: { image: nil } }

      follow_redirect!

      assert_select "div", text: /Snaps! Something went wrong, try again\./
    end

    test "redirect to edit user if has no original avatar" do
      get edit_me_avatar_path

      assert_redirected_to edit_user_registration_path

      follow_redirect!

      assert_select "div", text: /Upload an avatar first/
    end
  end
end
