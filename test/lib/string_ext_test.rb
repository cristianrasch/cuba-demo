require "minitest/autorun"

require_relative "../../lib/string_ext"

class StringExtTest < MiniTest::Unit::TestCase
  def test_string_is_blank
    assert "".blank?
    assert " ".blank?
  end
  
  def test_string_is_present
    refute "".present?
    refute " ".present?
    assert " blah ".present?
  end
end
