require "test_helper"

class PageLayoutHelperTest < ActionView::TestCase
  test "force js by default" do
    assert force_js
    assert_not force_js(false)
    assert_not force_js
    assert force_js(true)
    assert force_js
  end

  test "should return last set option" do
    page_layout :empty
    assert_equal :empty, page_layout
    page_layout :rawify
    assert_equal :rawify, page_layout
  end

  test "should return last set option on profile nav" do
    profile_nav true
    assert profile_nav
    profile_nav false
    assert_not profile_nav
  end

  test "should return last set option on page footer" do
    page_footer true
    assert page_footer
    page_footer false
    assert_not page_footer
  end

  test "should return last set option on body classes" do
    body_classes "foo"
    assert_equal "foo", body_classes
    body_classes "bar"
    assert_equal "bar", body_classes
  end

  test "contains controller name as a class" do
    assert_equal "test ", page_classes
  end

  test "container additional class" do
    assert_equal "foo test ", page_classes("foo")
  end
end
