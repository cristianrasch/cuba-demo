require "minitest/autorun"
require "capybara/dsl"

require_relative "../app"

class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  
  def setup
    Capybara.app = Cuba
    Capybara.javascript_driver = :webkit
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

class UserSessionTestCase < CapybaraTestCase
  def setup
    super
    
    visit "/login"
    fill_in "email", :with => "admin@example.com"
    fill_in "password", :with => "change-me"
    click_button "Login"
  end
end

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

class AppSessionTest < UserSessionTestCase
  # def test_logout
  #   visit "/tasks"
    
  #   assert_equal "/tasks", current_path
  #   click_link "Logout"
  #   page.execute_script "$('#logout-form').submit()"
  #   save_and_open_page
  #   assert_equal "/", current_path
  # end
  
  def test_tasks
    visit "/tasks"
    
    assert_equal "/tasks", current_path
    today = Date.today.strftime("%d/%m/%Y")
    page.has_content?("Tasks due on #{today}")
    assert find("ul#tasks")
    assert find("li.task")
  end
  
  def test_tasks_due_on_a_certain_date
    visit "/tasks/29/5/1985"
    
    assert_equal "/tasks/29/5/1985", current_path
    page.has_content?("Tasks due on 29/05/1985")
    assert find("ul#tasks")
    assert find("li.task")
  end
end

