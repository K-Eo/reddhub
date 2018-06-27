require "test_helper"

class PodTest < ActiveSupport::TestCase
  test "extracting meta" do
    content = "# My title\n\nMy description\n\nMy content\n\nMy extra content"
    title, description, body = Reddhub::Pod.parse_story(content)
    assert_equal "My title", title
    assert_equal "My description", description
    assert_equal "My content\n\nMy extra content", body

    content = "# My title\n\n# My description\n\n# My content"
    title, description, body = Reddhub::Pod.parse_story(content)
    assert_equal "My title", title
    assert_equal "# My description", description
    assert_equal "# My content", body

    content = nil
    assert_nil Reddhub::Pod.parse_story(content)

    content = ""
    assert_nil Reddhub::Pod.parse_story(content)

    content = "# My title\n\n"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "# My title\n\n\n\nMy Content"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "# My title\n\n My description\n\n#My content"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "My title\n\nMy description"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "#  My title\n\nMy description"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "#My title\n\nMy description"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "# My title\n\nMy description\n"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "# My title\n\nMy description\n\n "
    assert_nil Reddhub::Pod.parse_story(content)

    content = " # My title\n\nMy description"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "## My title\n\nMy description"
    assert_nil Reddhub::Pod.parse_story(content)

    content = "  My title\n\nMy description"
    assert_nil Reddhub::Pod.parse_story(content)

  end
end
