require "application_system_test_case"

class StoriesTest < ApplicationSystemTestCase
  setup do
    @user = users(:eo)
    @story = stories(:one)
  end

  test "visiting the index" do
    sign_in_as(@user)
    visit root_url
    assert_selector "h1", text: "Title of a longer featured blog post"
  end

  test "creating a Story" do
    sign_in_as(@user)
    visit root_url
    click_on "New Story"
    find(".story-editor").set @story.content
    assert_selector "span.disabled", text: "Not saved", visible: true
    assert_selector "span.disabled", text: "Saved", visible: true, wait: 10
  end

  test "destroying a Story" do
    sign_in_as(@user)
    visit root_url

    click_on "Story One"

    page.accept_confirm do
      click_on "Destroy"
    end

    assert_text "Story was successfully destroyed"
  end

  test "can't edit other user story" do
    sign_in_as(@user)
    visit root_url

    click_on "Story Two"

    assert has_no_button?("Edit")
  end

  test "can't destroy other user story" do
    sign_in_as(@user)
    visit root_url

    click_on "Story Two"

    assert has_no_button?("Destroy")
  end
end
