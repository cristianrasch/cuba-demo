require "minitest/autorun"

require_relative "../../lib/view_helper"

class ViewHelperTest < MiniTest::Unit::TestCase
  def setup
    @obj = Object.new
    class << @obj
      include ViewHelper
      
      def render(template, locals)
        html = File.read(template)
        locals.each do |k, v|
          html.gsub! k.to_s, v
        end
        html
      end
      
      def write(html); html; end
    end
  end
  
  def test_render_view
    html = @obj._render("index")
    assert_match html, /Cristian Rasch/ # 'layout' match
    assert_match html, /cuba/i # 'partial' match
  end
end
