require "minitest/autorun"
require "date"

require_relative "../../lib/date_helper"

class DateHelperTest < MiniTest::Unit::TestCase
  def setup
    @obj = Object.new
    @obj.extend DateHelper
  end
  
  def test_date_formatting
    date = Date.new(1985, 5, 29)
    assert_equal "29/05/1985", @obj.format_date(date)
  end
  
  def test_invalid_date_parsing
    assert_nil @obj.parse_date(30, 2, 2005)
  end
  
  def test_date_parsing
    date = Date.new(1985, 5, 29)
    assert_equal date, @obj.parse_date(29, 5, 1985)
  end
end
