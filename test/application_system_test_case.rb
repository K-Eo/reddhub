require "test_helper"

module SignInHelper
  def sign_in_as(user)
    visit root_path

    click_on "Sign In"

    fill_in "Email", with: user.email
    fill_in "Password", with: "password"

    click_on "Log in"

    assert_text "New Story"
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include SignInHelper

  driven_by :selenium,
            using: :chrome,
            screen_size: [1366, 768],
            options: { browser: :remote, desired_capabilities: :chrome }
end
