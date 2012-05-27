require "minitest/autorun"
require "date"

require_relative "../../models/task"

class TaskTest < MiniTest::Unit::TestCase
  def test_it_has_a_name
    task = Task.new("do the dishes")
    assert_equal "do the dishes", task.name
  end
  
  def test_retrieves_tasks_due_on_a_certain_date
    today = Date.today
    tasks = Task.due(today)
    
    refute_empty tasks
    regexp = Regexp.new("#\\d+ task due #{today.strftime '%d/%m/%Y'}")
    tasks.each do |task|
      assert_match task.name, regexp
    end
  end
end
