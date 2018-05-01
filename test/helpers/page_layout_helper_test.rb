require "test_helper"

class PageLayoutHelperTest < ActionView::TestCase
  class PageRaw < PageLayoutHelperTest
    test "should return false by default" do
      assert_not page_raw
    end

    test "should return last set option" do
      page_raw true
      assert page_raw
      page_raw false
      assert_not page_raw
    end
  end

  class PageFooter < PageLayoutHelperTest
    test "should return false by default" do
      assert_not page_footer
    end

    test "should return last set option" do
      page_footer true
      assert page_footer
      page_footer false
      assert_not page_footer
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
