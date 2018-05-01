require "application_system_test_case"

class StoriesTest < ApplicationSystemTestCase
  setup do
    @user = users(:eo)
    @story = stories(:one)
  end

  test "visiting the index" do
    sign_in_as(@user)
    visit stories_url
    assert_selector "h5", text: "Story One"
    assert_no_selector "h5", text: "Story Three"
  end

  test "visiting the index with public scope" do
    sign_in_as(@user)
    visit stories_url
    click_on "Public"
    assert_no_selector "h5", text: "Story One"
    assert_selector "h5", text: "Story Three"
  end

  test "creating a Story" do
    sign_in_as(@user)
    visit root_url
    click_on "New Story"
    assert_selector "a", text: "Write"
  end

  test "updating a Story" do
    sign_in_as(@user)
    visit stories_url
    click_on "Story One"
    find("#story_content").set "Foo bar"
    click_on "Update Story"
    visit story_url(@story)
    assert_text "Foo bar"
  end

  test "can't edit other user story" do
    sign_in_as(users(:kat))
    visit root_url

    click_on "Story Three"

    assert has_no_button?("Edit")
  end

  test "can't destroy other user story" do
    sign_in_as(users(:kat))
    visit root_url

    click_on "Story Three"

    assert has_no_button?("Destroy")
  end
end
