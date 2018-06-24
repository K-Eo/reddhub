require "test_helper"

class ReactionTest < ActiveSupport::TestCase
  test "returns options" do
    options = {
      "One" => "+1",
      "Heart" => "heart",
      "Laughing" => "laughing",
      "Astonished" => "astonished",
      "Disappointed" => "disappointed_relieved",
      "Rage" => "rage"
    }

    assert_equal options, Reddhub::Reaction.options
  end

  test "returns values" do
    values = [
      "+1",
      "heart",
      "laughing",
      "astonished",
      "disappointed_relieved",
      "rage"
    ]

    assert_equal values, Reddhub::Reaction.values
  end

  test "returns default" do
    assert_equal "+1", Reddhub::Reaction.default
  end

  test "sanitize" do
    assert_equal "+1", Reddhub::Reaction.sanitize("+1")
    assert_equal "heart", Reddhub::Reaction.sanitize("heart")
    assert_equal "laughing", Reddhub::Reaction.sanitize("laughing")
    assert_equal "astonished", Reddhub::Reaction.sanitize("astonished")
    assert_equal "disappointed_relieved", Reddhub::Reaction.sanitize("disappointed_relieved")
    assert_equal "rage", Reddhub::Reaction.sanitize("rage")
    assert_equal "+1", Reddhub::Reaction.sanitize(nil)
    assert_equal "+1", Reddhub::Reaction.sanitize("foo")
    assert_equal "+1", Reddhub::Reaction.sanitize("")
  end

  test "defines reactions" do
    assert_equal "+1", Reddhub::Reaction::ONE
    assert_equal "heart", Reddhub::Reaction::HEART
    assert_equal "laughing", Reddhub::Reaction::LAUGHING
    assert_equal "astonished", Reddhub::Reaction::ASTONISHED
    assert_equal "disappointed_relieved", Reddhub::Reaction::DISAPPOINTED
    assert_equal "rage", Reddhub::Reaction::RAGE
  end
end
