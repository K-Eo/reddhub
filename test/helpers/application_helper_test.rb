require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  class ConditionalClass < ApplicationHelperTest
    test "returns active when condition is true" do
      assert_equal "active", conditional_class(true, "active")
    end

    test "returns empty when condition is false" do
      assert_equal "", conditional_class(false, "active")
    end

    test "returns active and additional class" do
      assert_equal "foo active", conditional_class(true, "active", "foo")
    end

    test "returns only additional class" do
      assert_equal "foo", conditional_class(false, "active", "foo")
    end
  end

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

  class InvalidWhen < ApplicationHelperTest
    test "returns active when condition is true" do
      assert_equal "is-invalid", invalid_when(true)
    end

    test "returns empty when condition is false" do
      assert_equal "", invalid_when(false)
    end

    test "returns active and additional class" do
      assert_equal "foo is-invalid", invalid_when(true, "foo")
    end

    test "returns only additional class" do
      assert_equal "foo", invalid_when(false, "foo")
    end
  end
end
