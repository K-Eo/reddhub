require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  class ActiveWhen < ApplicationHelperTest
    test "returns active when condition is true" do
      assert_equal "active", active_when(true)
    end

    test "returns empty when condition is false" do
      assert_equal "", active_when(false)
    end

    test "returns active and additional class" do
      assert_equal "foo active", active_when(true, "foo")
    end

    test "returns only additional class" do
      assert_equal "foo", active_when(false, "foo")
    end
  end
end
