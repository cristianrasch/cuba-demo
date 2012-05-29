require "minitest/autorun"
require "factory_girl"

require_relative "../../db/task_dao"
require_relative "../factories/task"

class TaskDAOTest < MiniTest::Unit::TestCase
  def teardown
    TaskDAO.delete_all
  end
  
  def test_finds_a_task_by_name_and_due_on_date
    task = FactoryGirl.create(:task, name: "walk the dog")
    found_task = TaskDAO.find_by_name_and_due_on("Walk the dog", task.due_on)
    refute_nil found_task
  end
  
  def test_saved_a_new_task
    task = FactoryGirl.build(:task)
    task_id = TaskDAO.save(task)
    assert task_id > 0
  end
  
  def test_finds_all_tasks_by_due_on
    tomorrow = Date.today + 1
    3.times { FactoryGirl.create(:task, due_on: tomorrow) }
    tasks = TaskDAO.find_all_by_due_on(tomorrow)
    assert_equal 3, tasks.length
  end
end
