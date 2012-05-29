require "minitest/autorun"
require "date"

require_relative "../../models/task"
require_relative "../factories/task"

class TaskTest < MiniTest::Unit::TestCase
  def test_it_has_a_name_and_a_due_on_date
    task = FactoryGirl.build(:task)
    assert_match task.name, /#\d+ task/i
    assert task.due_on
    assert_equal Date.today, task.created_at.to_date
  end
  
  def test_tasks_default_created_at_date
    assert_equal Date.today, Task.new.created_at.to_date
  end
  
  def test_its_created_at_writer
    utc_now = Time.now.utc
    assert_equal utc_now.to_i, Task.new(created_at: utc_now).created_at.to_i
    assert_equal utc_now.to_i, Task.new(created_at: utc_now.to_i).created_at.to_i
  end
  
  def test_name_should_be_present
    refute Task.new(name: " ").valid?
  end
  
  def test_due_on_should_be_present
    refute Task.new(name: "wash the car").valid?
  end
  
  def test_due_on_should_be_greater_or_equal_than_today
    yesterday = Date.today - 1
    task = Task.new(name: "wash the car", due_on: yesterday)
    refute task.valid?
  end
  
  def test_name_should_be_unique_for_that_due_on_date
    task = FactoryGirl.create(:task)
    new_task = Task.new(name: task.name, due_on: task.due_on)
    refute new_task.valid?
  end
  
  def test_saves_valid_tasks
    task = FactoryGirl.build(:task)
    task_id = task.save
    assert task_id
    assert task_id > 0
  end
  
  def test_does_not_save_invalid_tasks
    task_id = Task.new.save
    assert_nil task_id
  end
  
  def test_compares_two_tasks_for_equality
    name, due_date = "do the laundry", Date.today
    t1 = Task.new(name: name, due_on: due_date)
    t2 = Task.new(name: name, due_on: due_date)
    assert_equal t1, t2
  end
  
  def test_finds_tasks_due_on_a_certain_date
    today = Date.today
    (1..3).each do |i|
      FactoryGirl.create(:task, name: "Task ##{i}", due_on: today)
    end
    tasks = Task.due_on(today)
    
    refute_empty tasks
    regexp = Regexp.new("Task #\\d+")
    assert tasks.all? { |task| task.name =~ regexp }
  end
end
