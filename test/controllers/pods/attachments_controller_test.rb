require "test_helper"

class Pods::AttachmentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @pod = pods(:one)
    @user = @pod.user
  end

  test "redirects to login" do
    assert_not @pod.images.attached?
    post pod_attachments_path(@pod)
    assert_not @pod.images.attached?

    assert_redirected_to new_user_session_path
  end

  test "attaching image to pod" do
    sign_in @user

    assert_not @pod.images.attached?
    post pod_attachments_path(@pod), params: { pod_attachment: { image: fixture_file_upload("files/cover.jpeg") } }
    assert @pod.images.attached?

    assert_redirected_to user_pod_path(@user.username, @pod)
  end

  test "only pod owner can attach images" do
    sign_in users(:cassian)

    assert_not @pod.images.attached?
    post pod_attachments_path(@pod), params: { pod_attachment: { image: fixture_file_upload("files/cover.jpeg") } }
    assert_not @pod.images.attached?

    assert_response :not_found
  end
end
