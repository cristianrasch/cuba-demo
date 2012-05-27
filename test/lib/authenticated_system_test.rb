require "minitest/autorun"

require_relative "../../lib/authenticated_system"
require_relative "../../models/user"

class AuthenticatedSytemTest < MiniTest::Unit::TestCase
  def setup
    @obj = Object.new
    @obj.extend AuthenticatedSystem
  end
  
  def test_current_user_is_nil_if_user_has_not_signed_in
    def @obj._session(key); nil; end
    assert_nil @obj.current_user
    refute @obj.logged_in?
  end
  
  def test_current_user_is_not_authorized
    def @obj._session(key); "not-admin@example.com"; end
    assert_nil @obj.current_user
    refute @obj.logged_in?
  end
  
  def test_current_user_is_not_nil_if_user_has_signed_in
    def @obj._session(key); "admin@example.com"; end
    assert @obj.current_user
    assert @obj.logged_in?
  end
  
  def test_user_is_redirected_if_not_logged_in
    class << @obj
      def logged_in?; false; end
      def redirect_to(path); path unless logged_in?; end
    end
    assert_equal "/login", @obj.login_required
  end
  
  def test_user_is_not_redirected_if_logged_in
    class << @obj
      def logged_in?; true; end
      def redirect_to(path); path unless logged_in?; end
    end
    assert_nil @obj.login_required
  end
end
