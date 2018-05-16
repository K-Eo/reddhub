require "application_system_test_case"

class AvatarsTest < ApplicationSystemTestCase
  setup do
    Capybara.current_session.driver.browser.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end

    @user = users(:bilbo)
  end

  test "visiting avatar" do
    sign_in_as(@user)
    visit edit_user_registration_url

    assert_selector "img[src^='https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04']", count: 2
  end

  test "updating avatar" do
    sign_in_as(@user)
    visit edit_user_registration_url

    assert_selector "img[src^='https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04']", count: 2
    find("input[type=file]", visible: false).set(file_fixture("avatar.png"))
    assert_selector "button", text: "Save changes", visible: true, count: 1
    click_button "Save changes"
    assert_selector "img[src^='https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04']", count: 0
    assert_selector "img[src*=blob]", count: 2
  end
end
