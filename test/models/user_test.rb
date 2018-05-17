require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(
      email: "foo@bar.com",
      password: "password",
      password_confirmation: "password",
      username: "foobar",
      name: "Foo Bar"
    )
  end

  test "valid user" do
    assert @user.valid?
  end

  test "invalid without username" do
    @user.username = nil
    assert_not @user.valid?
  end

  test "invalid with short username" do
    @user.username = "aaa"
    assert_not @user.valid?
  end

  test "invalid with not permitted characters in username" do
    @user.username = '!@#$%^&*()+-={}[];\':"<>/\\|~`'
    assert_not @user.valid?

    @user.username = "-foo"
    assert_not @user.valid?

    @user.username = "foo-"
    assert_not @user.valid?

    @user.username = ".foo"
    assert_not @user.valid?

    @user.username = ".foo."
    assert_not @user.valid?

    @user.username = "aaa)"
    assert_not @user.valid?
  end

  test "invalid with too long username" do
    @user.username = "a" * 33
    assert_not @user.valid?
  end

  test "valid usernames" do
    @user.username = "foobar"
    assert @user.valid?

    @user.username = "_foobar"
    assert @user.valid?

    @user.username = "foo_bar"
    assert @user.valid?

    @user.username = "foobar_"
    assert @user.valid?

    @user.username = "FOOBAR"
    assert @user.valid?

    @user.username = "Foobar"
    assert @user.valid?
  end

  test "invalid if username already exists" do
    @user.save
    second = User.new(
      email: "second@mail.com",
      password: "password",
      password_confirmation: "password",
      username: "FOOBAR"
    )

    assert_not second.valid?
  end

  test "invalid without name" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "invalid if name is too long" do
    @user.name = "f" * 97
    assert_not @user.valid?
  end

  test "invalid without correct format" do
    @user.name = "eo eo"
    assert_not @user.valid?

    @user.name = "1234567890"
    assert_not @user.valid?

    @user.name = "----"
    assert_not @user.valid?

    @user.name = "Eo Eo Eo"
    assert @user.valid?

    @user.name = "Eo Eo Eo"
    assert @user.valid?

    @user.name = "Eo"
    assert @user.valid?
  end

  class Followers < UserTest
    def setup
      @kat = users(:thorin)
      @eo = users(:bilbo)
    end

    test "should follow an unfollow a user" do
      assert_not @kat.following?(@eo)
      @kat.follow(@eo)
      assert @kat.following?(@eo)
      assert @eo.followers.include?(@kat)
      @kat.unfollow(@eo)
      assert_not @kat.following?(@eo)
    end

    test "should update followers and following counter caches" do
      assert_equal 0, @kat.following_count
      assert_equal 0, @kat.followers_count
      assert_equal 0, @eo.following_count
      assert_equal 0, @eo.followers_count

      @kat.follow(@eo)

      assert_equal 1, @kat.reload.following_count
      assert_equal 0, @kat.reload.followers_count
      assert_equal 0, @eo.reload.following_count
      assert_equal 1, @eo.reload.followers_count

      @kat.unfollow(@eo)

      assert_equal 0, @kat.reload.following_count
      assert_equal 0, @kat.reload.followers_count
      assert_equal 0, @eo.reload.following_count
      assert_equal 0, @eo.reload.followers_count
    end
  end

  class Feed < UserTest
    test "feed should have the right pods" do
      bilbo = users(:bilbo)
      thorin = users(:thorin)
      marty = users(:marty)

      bilbo.follow(thorin)

      thorin.pods.each do |pod|
        assert bilbo.feed.include?(pod)
      end

      bilbo.pods.each do |pod|
        assert bilbo.feed.include?(pod)
      end

      marty.pods.each do |pod|
        assert_not bilbo.feed.include?(pod)
      end
    end
  end
end
