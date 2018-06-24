require "test_helper"

class AccessTest < ActiveSupport::TestCase
  test "returns options" do
    options = {
      "User" => 0,
      "Root" => 100
    }

    assert_equal options, Reddhub::Access.options
  end

  test "returns options values" do
    assert_equal [0, 100], Reddhub::Access.values
  end

  test "defines default levels" do
    assert_equal 0, Reddhub::Access::USER
    assert_equal 100, Reddhub::Access::ROOT
  end
end
