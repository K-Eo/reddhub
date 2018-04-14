require 'test_helper'

class StoryPolicyTest < PolicyAssertions::Test
  setup do
    @user = users(:eo)
    @record = stories(:one)
  end

  def test_index_and_show
    assert_permit nil, Story
  end

  def test_new_and_create
    assert_permit @user, Story
  end

  def test_update_and_edit
    assert_permit @user, @record
    assert_not_permitted @user, stories(:two)
  end

  def test_destroy
    assert_permit @user, @record
    assert_not_permitted @user, stories(:two)
  end
end
