require "date"

require_relative "model"
require_relative "../lib/string_ext"
require_relative "../db/task_dao"

class Task < Model
  attr_accessor :name, :due_on

  def initialize(options = {})
    options.each do |k, v|
      instance_variable_set "@#{k}".to_sym, v
    end
  end
  
  def ==(other)
    name == other.name && due_on == other.due_on
  end
  
  def created_at=(date)
    @created_at = case date
                  when Date then date
                  when Numeric then Time.at(date).utc
                  end
  end
  
  def created_at
    @created || Time.now.utc
  end
  
  def valid?
    return false if name.nil? || name.blank?
    return false if due_on.nil?
    return false if due_on < Date.today
    TaskDAO.find_by_name_and_due_on(name, due_on).nil?
  end
  
  def save
    ::TaskDAO.save(self) if valid?
  end
  
  class << self
    def due_on(due_date)
      ::TaskDAO.find_all_by_due_on(due_date).map do |attrs|
        new attrs
      end
    end
    
    def delete_all
      ::TaskDAO.delete_all
    end
  end
end

