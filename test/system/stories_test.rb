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
    assert_selector "span.disabled", text: "New", visible: true
    find(".story-editor").set @story.content
    assert_selector "span.disabled", text: "Not saved", visible: true
    assert_selector "span.disabled", text: "Saved", visible: true, wait: 10
  end

  test "updating a Story" do
    sign_in_as(@user)
    visit stories_url
    click_on "Story One"
    assert_selector "span.disabled", text: "Saved", visible: true
    find(".story-editor").set "Foo bar"
    assert_selector "span.disabled", text: "Not saved", visible: true
    assert_selector "span.disabled", text: "Saved", visible: true, wait: 10
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
