require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:eo)
    @story = Story.new(title: 'Foo Bar', content: 'Foo Baz', user: @user)
  end

  test 'valid story' do
    assert @story.valid?
  end

  test 'invalid without title' do
    @story.title = nil
    assert_not @story.valid?
  end

  test 'invalid if title length is greater than 60 characters' do
    @story.title = 'a' * 61
    assert_not @story.valid?
  end

  test 'invalud without content' do
    @story.content = nil
    assert_not @story.valid?
  end
end
