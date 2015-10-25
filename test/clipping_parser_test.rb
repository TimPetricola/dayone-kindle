require 'test_helper'

class ClippingParserTest < Minitest::Test
  def test_parsing
    clipping = <<EOF
Shibumi (Trevanian)
- Your Highlight on Page 121 | Location 1851-1853 | Added on Friday, November 28, 2014 3:31:42 PM

Do not fall into the error of the artisan who boasts of twenty years experience in his craft while in fact he has had only one year of experience—twenty times.
EOF
    highlight = ClippingParser.new(clipping).highlight

    assert_equal 'Shibumi', highlight.book
    assert_equal ['Trevanian'], highlight.authors
    assert_equal 121, highlight.page
    assert_equal '1851-1853', highlight.location
    assert_equal Time.new(2014, 11, 28, 15, 31, 42), highlight.time
  end
end
