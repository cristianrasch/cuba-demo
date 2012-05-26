class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end
  
  def self.due_today
    (1..5).map do |i|
      Task.new "Task ##{i}"
    end
  end
end
