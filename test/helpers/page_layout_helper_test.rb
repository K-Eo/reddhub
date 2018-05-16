require "test_helper"

class PageLayoutHelperTest < ActionView::TestCase
  class PageLayout < PageLayoutHelperTest
    test "should return last set option" do
      page_layout :empty
      assert_equal :empty, page_layout
      page_layout :rawify
      assert_equal :rawify, page_layout
    end
  end

  class ProfileNav < PageLayoutHelperTest
    test "should return last set option" do
      profile_nav true
      assert profile_nav
      profile_nav false
      assert_not profile_nav
    end
  end

  class PageFooter < PageLayoutHelperTest
    test "should return last set option" do
      page_footer true
      assert page_footer
      page_footer false
      assert_not page_footer
    end
  end

  class BodyClasses < PageLayoutHelperTest
    test "should return last set option" do
      body_classes "foo"
      assert_equal "foo", body_classes
      body_classes "bar"
      assert_equal "bar", body_classes
    end
  end

  class PageClasses < PageLayoutHelperTest
    test "contains controller name as a class" do
      assert_equal "test ", page_classes
    end

    test "container additional class" do
      assert_equal "foo test ", page_classes("foo")
    end
  end
end
