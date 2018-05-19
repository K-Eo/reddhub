require "test_helper"

class AvatarHelperTest < ActionView::TestCase
  setup do
    @user = users(:bilbo)
  end

  test "should return default avatar image" do
    assert_dom_equal(
      %{<img src="https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04?s=256&d=mm" />},
      user_avatar(@user)
    )
  end

  test "should return user avatar" do
    @user.avatar.attach(fixture_file_upload("files/avatar.png"))
    result = user_avatar(@user)

    assert_match /<img src="/, result
    assert_match /avatar\.png/, result
  end

  test "passes aditional options" do
    @user.avatar.attach(fixture_file_upload("files/avatar.png"))

    assert_match(
      /class=\"foo bar\"/,
      user_avatar(@user, html: { class: "foo bar" })
    )
  end

  test "handles resize option" do
    @user.avatar.attach(fixture_file_upload("files/avatar.png"))
    original = user_avatar(@user)
    resized  = user_avatar(@user, resize: "30x30")

    assert_not_equal(original, resized)
  end

  test "return gravatar url" do
    assert_equal "https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04?s=256&d=mm", avatar_url(@user)
  end

  test "return avatar url" do
    @user.avatar.attach(fixture_file_upload("files/avatar.png"))
    assert_equal @user.avatar, avatar_url(@user)
  end

  test "return avatar variant" do
    @user.avatar.attach(fixture_file_upload("files/avatar.png"))
    assert avatar_url(@user, resize: "200x200")
    assert_not_equal @user.avatar, avatar_url(@user, resize: "200x200")
  end
end
