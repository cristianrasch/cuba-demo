require "minitest/autorun"

require_relative "../../models/user"

class UserTest < MiniTest::Unit::TestCase
  def setup
    @user = User.new("admin@example.com", "secret")
  end
  
  def test_it_has_an_email_and_password
    assert_equal "admin@example.com", @user.email
    assert_equal "secret", @user.password
  end
  
  def test_is_authenticated_by_a_password
    assert @user.authenticated_by?("secret")
    refute @user.authenticated_by?("blah..")
  end
  
  def test_retrieves_users_based_on_their_email_address
    assert User.find_by_email("admin@example.com")
    assert User.find_by_email("ADMIN@example.com")
    assert_nil User.find_by_email("not-admin@example.com")
  end
end
