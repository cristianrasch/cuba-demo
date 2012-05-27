require "minitest/autorun"
require "capybara/dsl"

require_relative "../app"

class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

Capybara.app = Cuba

class AppTest < CapybaraTestCase
  def test_root
    visit "/"
    
    assert_equal "/", current_path
    page.has_content?("Cuba")
  end
  
  def test_login
    visit "/login"
    
    assert_equal "/login", current_path
    fill_in "email", :with => "admin@example.com"
    fill_in "password", :with => "change-me"
    click_button "Login"
    
    assert_equal "/tasks", current_path
  end
  
  def test_login_with_empty_password
    visit "/login"
    
    assert_equal "/login", current_path
    fill_in "email", :with => "admin@example.com"
    click_button "Login"
    
    assert_equal "/session", current_path
    err = find("div.error")
    assert err
    assert_match err.text, /Email or password missing/
  end
  
  def test_login_with_invalid_credentials
    visit "/login"
    
    assert_equal "/login", current_path
    fill_in "email", :with => "not-admin@example.com"
    fill_in "password", :with => "don't know"
    click_button "Login"
    
    assert_equal "/session", current_path
    err = find("div.error")
    assert err
    assert_match err.text, /Invalid email or password/
  end
end
