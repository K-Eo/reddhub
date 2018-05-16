require "test_helper"

class PodTest < ActiveSupport::TestCase
  def setup
    @user = users(:bilbo)
    @pod = Pod.new(user: @user, content: "Foo bar")
  end

  test "is valid" do
    assert @pod.valid?
  end

  test "is invalid without content" do
    @pod.content = nil
    assert_not @pod.valid?
  end

  test "is invalid if content is too long" do
    @pod.content = "a" * 257
    assert_not @pod.valid?
  end

  test "is invalid if has no user" do
    @pod.user = nil
    assert_not @pod.valid?
  end

  class Likes < PodTest
    def setup
      super
      @pod.save
    end

    test "creates like" do
      assert_difference "Like.count" do
        assert @pod.liked_by(@user)
      end

      like = Like.first
      assert_equal like.user, @user
    end

    test "ignores doubles like" do
      @pod.liked_by(@user)

      assert_no_difference "Like.count" do
        assert @pod.liked_by(@user)
      end
    end

    test "destroys like" do
      @pod.liked_by(@user)

      assert_difference "Like.count", -1 do
        assert @pod.unliked_by(@user)
      end
    end
  end
end
