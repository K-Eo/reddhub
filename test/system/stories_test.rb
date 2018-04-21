require "application_system_test_case"

class StoriesTest < ApplicationSystemTestCase
  setup do
    @user = users(:eo)
    @story = stories(:one)
  end

  test "visiting the index" do
    sign_in_as(@user)
    visit stories_url
    assert_selector "h3", text: "Stories"
  end

  test "creating a Story" do
    sign_in_as(@user)
    visit stories_url
    click_on "New Story"

    fill_in "Title", with: @story.title
    fill_in "Content", with: @story.content
    click_on "Create Story"

    assert_text "Story was successfully created"
  end

  test "updating a Story" do
    sign_in_as(@user)
    visit stories_url

    click_on "Story One"

    click_on "Edit"

    fill_in "Content", with: @story.content
    fill_in "Title", with: @story.title
    click_on "Update Story"

    assert_text "Story was successfully updated"
  end

  test "destroying a Story" do
    sign_in_as(@user)
    visit stories_url

    click_on "Story One"

    page.accept_confirm do
      click_on "Destroy"
    end

    assert_text "Story was successfully destroyed"
  end

  test "can't edit other user story" do
    sign_in_as(@user)
    visit stories_url

    click_on "Story Two"

    assert has_no_button?("Edit")
  end

  test "can't destroy other user story" do
    sign_in_as(@user)
    visit stories_url

    click_on "Story Two"

    assert has_no_button?("Destroy")
  end
end
