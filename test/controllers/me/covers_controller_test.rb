require "test_helper"

class Me::CoversControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bilbo)
  end

  test "renders placeholder" do
    sign_in(@user)

    get root_path

    assert_response :ok

    assert_select "div.cover"

    get edit_user_registration_path

    assert_response :ok

    assert_select "div.cover"
  end

  test "renders cover" do
    @user.cover.attach(fixture_file_upload("files/cover.jpeg"))
    sign_in(@user)

    get root_path

    assert_response :ok

    assert_select "img.cover"

    get edit_user_registration_path

    assert_response :ok

    assert_select "img.rounded"
  end

  test "uploading cover" do
    sign_in(@user)

    get edit_user_registration_path

    assert_response :ok

    assert_select "div.cover"
    assert_select "form#new_cover" do
      assert_select "input#cover_image"
      assert_select "input[type=submit]"
    end

    post me_cover_path, params: { cover: { image: fixture_file_upload("files/cover.jpeg") } }

    assert_redirected_to edit_user_registration_path

    follow_redirect!

    assert_select "img[src*='cover.jpeg']"
    assert_select "div", /You have successfully uploaded your cover/
  end

  test "renders message if cover upload has failed" do
    sign_in(@user)

    get edit_user_registration_path

    assert_response :ok

    assert_select "div.cover"
    assert_select "form#new_cover" do
      assert_select "input#cover_image"
      assert_select "input[type=submit]"
    end

    post me_cover_path, params: { cover: { image: nil } }

    assert_redirected_to edit_user_registration_path

    follow_redirect!

    assert_select "img[src*='cover.jpeg']", count: 0
    assert_select "div.alert", /Snaps! Something went wrong\. Try again/
  end

  test "renders message if cover param is missing" do
    sign_in(@user)

    post me_cover_path

    assert_redirected_to edit_user_registration_path

    follow_redirect!

    assert_select "div.alert", /Select an image to be used as a cover\./
  end

  test "redirects to login" do
    post me_cover_path, params: { cover: { image: fixture_file_upload("files/cover.jpeg") } }

    assert_redirected_to new_user_session_path
  end
end
