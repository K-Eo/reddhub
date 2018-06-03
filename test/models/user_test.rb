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

  test "is not guest" do
    assert_not users(:bilbo).guest?
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
    ['!@#$%^&*()+-={}[];\':"<>/\\|~`', "-foo", "foo-", ".foo", ".foo.", "aaa)"].each do |i|
      @user.username = i
      assert_not @user.valid?
    end
  end

  test "invalid with too long username" do
    @user.username = "a" * 33
    assert_not @user.valid?
  end

  test "valid usernames" do
    ["foobar", "_foobar", "foo_bar", "foobar_", "FOOBAR", "Foobar"].each do |i|
      @user.username = i
      assert @user.valid?
    end
  end

  test "invalid if username is reserved" do
    ["reddhub", "REDDHUB", "redd", "hub", "REDD"].each do |i|
      @user.username = i
      assert_not @user.valid?
    end
  end

  test "invalid if username already exists" do
    @user.save
    second = User.new(
      email: "second@mail.com",
      password: "password",
      password_confirmation: "password",
      username: "FOOBAR",
      name: "Foo Bar"
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
    ["eo eo", "1234567890", "----", " Diego Lopez", "Diego Lopez ", " Diego", "Diego ", " Diego "].each do |i|
      @user.name = i
      assert_not @user.valid?
    end
  end

  test "valid with correct format" do
    ["Eo Eo Eo", "Eo Eo Eo", "Eo", "Marty McFly", "Thorin II Oakenshield", "Thorin I Oakenshield", "Diego Lopez", "Diego L"].each do |i|
      @user.name = i
      assert @user.valid?
    end
  end

  test "reactions_for returns reactions" do
    user = users(:bilbo)
    pod1 = pods(:seven)
    pod2 = pods(:eight)
    pod3 = pods(:nine)

    reactions = user.reactions_for(users(:doc).pods.all, "Pod")
    assert reactions.is_a?(Hash)

    reaction = reactions[pod1.id]
    assert_equal user, reaction.user
    assert_equal "+1", reaction.name

    reaction = reactions[pod2.id]
    assert_not reaction

    reaction = reactions[pod3.id]
    assert_equal user, reaction.user
    assert_equal "rage", reaction.name
  end

  test "reactions_for returns empty hash if user is guest" do
    user = Guest.new
    reactions = user.reactions_for(users(:bilbo).pods.all, "Pod")
    assert reactions.empty?
  end

  test "returns reaction" do
    user = users(:bilbo)
    pod = pods(:one)
    pod.reactions.create!(user: user, name: "+1")

    reaction = user.reaction(pod)
    assert reaction
    assert_equal user, reaction.user
    assert_equal "+1", reaction.name
  end

  test "reaction returns nil if reaction does not exist" do
    pod = pods(:one)
    assert_not @user.reaction(pod)
  end

  test "reaction returns nil if user is guest" do
    user = Guest.new
    pod = pods(:one)

    assert_not user.reaction(pod)
  end

  test "returns true if user has reacted" do
    reaction = Reaction.create!(user: @user, reactable: pods(:one), name: "+1")

    assert @user.reacted?(reaction)
  end

  test "reacted returns false if reaction is nil" do
    pod = pods(:one)

    assert_not @user.reacted?(nil)
  end

  test "reacted returns false if user is guest" do
    reaction = Reaction.create!(user: @user, reactable: pods(:one), name: "+1")
    user = Guest.new

    assert_not user.reacted?(reaction)
  end

  test "reacted returns false if users are not equals" do
    reaction = Reaction.create!(user: users(:thorin), reactable: pods(:one), name: "+1")

    assert_not @user.reacted?(reaction)
  end

  test "creating reaction on pod" do
    user = users(:bilbo)
    pod = pods(:one)

    assert_difference "pod.reactions.count" do
      @reaction = user.react(pod, "+1")
    end

    assert_equal user, @reaction.user
    assert_equal "+1", @reaction.name
  end

  test "destroying reaction on pod" do
    user = users(:thorin)
    pod = pods(:with_reactions)

    assert_difference "pod.reactions.count", -1 do
      user.unreact(pod)
    end
  end

  test "creating reaction on comment" do
    user = users(:bilbo)
    comment = comments(:welcome)

    assert_difference "comment.reactions.count" do
      @reaction = user.react(comment, "+1")
    end

    assert_equal user, @reaction.user
    assert_equal "+1", @reaction.name
  end

  test "destroying reaction on comment" do
    user = users(:thorin)
    comment = comments(:with_reactions)

    assert_difference "comment.reactions.count", -1 do
      user.unreact(comment)
    end
  end

  test "normalizes reaction" do
    user = users(:bilbo)
    pod = pods(:one)

    assert_difference "pod.reactions.count" do
      @reaction = user.react(pod, "foo")
    end

    assert_equal user, @reaction.user
    assert_equal "+1", @reaction.name
  end

  test "creates default reaction if name is nil" do
    user = users(:bilbo)
    pod = pods(:one)

    assert_difference "pod.reactions.count" do
      @reaction = user.react(pod, nil)
    end

    assert_equal user, @reaction.user
    assert_equal "+1", @reaction.name
  end

  test "following user" do
    follower = users(:cassian)
    followed = users(:doc)

    assert_not follower.following?(followed)
    assert_not follower.following.include?(followed)
    assert_not followed.followers.include?(follower)

    assert_difference ["follower.following.count", "followed.followers.count", "Relationship.count"] do
      follower.follow(followed)
    end

    assert follower.following?(followed)
    assert follower.following.include?(followed)
    assert followed.followers.include?(follower)
  end

  test "unfollowing user" do
    follower = users(:marty)
    followed = users(:doc)

    assert follower.following?(followed)
    assert follower.following.include?(followed)
    assert followed.followers.include?(follower)

    assert_difference ["follower.following.count", "followed.followers.count", "Relationship.count"], -1 do
      follower.unfollow(followed)
    end

    assert_not follower.following?(followed)
    assert_not follower.following.include?(followed)
    assert_not followed.followers.include?(followed)
  end

  test "raises if already following" do
    follower = users(:marty)
    followed = users(:doc)

    assert_raises(ActiveRecord::RecordNotUnique) do
      follower.follow(followed)
    end
  end

  test "can follow himself" do
    follower = users(:marty)
    followed = users(:marty)

    assert_raises(User::NotDifferentUsers) do
      follower.follow(followed)
    end
  end

  test "should update followers and following counter caches" do
    @kat = users(:thorin)
    @eo = users(:bilbo)
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
