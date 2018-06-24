require "test_helper"

class SanitizerTest < ActionView::TestCase
  test "removes extra break lines" do
    content = "a\n\n\nb\n\n\n\nc\n\nd\n\n\n"
    assert_equal "a\n\nb\n\nc\n\nd", Reddhub::Sanitizer.extra_space(content)
  end

  test "normalizes break lines" do
    content = "a\r\n\nb"
    assert_equal "a\n\nb", Reddhub::Sanitizer.extra_space(content)

    content = "a\r\n\r\n\r\nb\r\nc\r\n\r\n\r\n"
    assert_equal "a\n\nb\nc", Reddhub::Sanitizer.extra_space(content)

    content = "a\r\n\n\nb"
    assert_equal "a\n\nb", Reddhub::Sanitizer.extra_space(content)
  end

  test "removes spaces between new lines" do
    content = "a\n\s\s\n\s\s\nb\s\n\n\n\nc\n\nd\n\n\n"
    assert_equal "a\n\nb\n\nc\n\nd", Reddhub::Sanitizer.extra_space(content)
  end

  test "strips spaces" do
    content = "     abc    "
    assert_equal "abc", Reddhub::Sanitizer.extra_space(content)
  end
end
