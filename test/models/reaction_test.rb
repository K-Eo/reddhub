require "test_helper"

class ReactionTest < ActiveSupport::TestCase
  def setup
    @user = users(:bilbo)
    @pod = pods(:one)
    @reaction = Reaction.new(user: @user, reactable: @pod, name: "+1")
  end

  test "is valid" do
    assert @reaction.valid?
  end

  test "is invalid without user" do
    @reaction.user = nil
    assert_not @reaction.valid?
  end

  test "is invalid without name" do
    @reaction.name = nil
    assert_not @reaction.valid?
  end

  test "is valid with names collection" do
    names = ["+1", "heart", "laughing", "astonished", "disappointed_relieved", "rage"]

    names.each do |i|
      @reaction.name = i
      assert @reaction.valid?
    end

    @reaction.name = "foo"
    assert_not @reaction.valid?

    @reaction.name = "bar"
    assert_not @reaction.valid?
  end
end
