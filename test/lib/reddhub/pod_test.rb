require "test_helper"

class PodTest < ActiveSupport::TestCase
  test "check if is story" do
    content = "# My title\n\nMy description\n\nMy content"
    assert Reddhub::Pod.story?(content)

    content = "# My title\n\n# My description\n\n#My content"
    assert Reddhub::Pod.story?(content)

    content = nil
    assert_not Reddhub::Pod.story?(content)

    content = ""
    assert_not Reddhub::Pod.story?(content)

    content = "# My title\n\n My description\n\n#My content"
    assert_not Reddhub::Pod.story?(content)

    content = "My title\n\nMy description"
    assert_not Reddhub::Pod.story?(content)

    content = "#  My title\n\nMy description"
    assert_not Reddhub::Pod.story?(content)

    content = "#My title\n\nMy description"
    assert_not Reddhub::Pod.story?(content)

    content = "# My title\n\nMy description\n"
    assert_not Reddhub::Pod.story?(content)

    content = "# My title\n\nMy description\n\n "
    assert_not Reddhub::Pod.story?(content)

    content = " # My title\n\nMy description"
    assert_not Reddhub::Pod.story?(content)

    content = "## My title\n\nMy description"
    assert_not Reddhub::Pod.story?(content)

    content = "  My title\n\nMy description"
    assert_not Reddhub::Pod.story?(content)
  end

  test "extracting meta" do
    content = "# My title\n\nMy description\n\nMy content\n\nMy extra content"
    title, description, body = Reddhub::Pod.parse_story(content)

    assert_equal "My title", title
    assert_equal "My description", description
    assert_equal "My content\n\nMy extra content", body
  end
end
