require 'test_helper'

class HighlightTest < Minitest::Test
  def test_to_markdown
    highlight = DayOneKindle::Highlight.new(
      book: 'The Pragmatic Programmer: From Journeyman to Master',
      authors: ['Andrew Hunt', 'David Thomas'],
      highlight: 'Embrace the fact that debugging is just problem solving, and attack it as such.',
      time: Time.new(2014, 3, 5, 15, 4, 22),
      page: 121,
      location: '1850-1850'
    )

    expected_markdown = <<EOF
# Quote from The Pragmatic Programmer: From Journeyman to Master

By *Andrew Hunt* and *David Thomas*.

> Embrace the fact that debugging is just problem solving, and attack it as such.

Page 121 - Location 1850-1850
EOF
    expected_markdown.strip!

    assert_equal expected_markdown, highlight.to_markdown
  end
end
