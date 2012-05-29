require "minitest/autorun"
require "capybara/dsl"
require "factory_girl"
require "date"

require_relative "../app"
require_relative "../models/task"
require_relative "factories/task"

class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  
  def setup
    Capybara.app = Cuba
    # Capybara.javascript_driver = :webkit
  end

  def teardown
    Capybara.reset_sessions!
    # Capybara.use_default_driver
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
  
  def teardown
    super
    Task.delete_all
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
  def test_logout
    visit "/tasks"
    
    assert_equal "/tasks", current_path
    click_button "logout"
    assert_equal "/", current_path
  end
  
  def test_tasks
    today = Date.today
    FactoryGirl.create(:task, due_on: today)
    visit "/tasks"
    
    assert_equal "/tasks", current_path
    due_date = today.strftime("%d/%m/%Y")
    page.has_content?("Tasks due on #{due_date}")
    assert find("ul#tasks")
    assert find("li.task")
  end
  
  def test_tasks_due_on_a_certain_date
    tomorrow = Date.today + 1
    due_date = tomorrow.strftime("%d/%m/%Y")
    FactoryGirl.create(:task, due_on: tomorrow)
    path = "/tasks/#{due_date}" 
    visit path
    
    assert_equal path, current_path
    page.has_content?("Tasks due on #{due_date}")
    assert find("ul#tasks")
    assert find("li.task")
  end
end

