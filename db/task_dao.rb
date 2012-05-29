require_relative "dao"

class TaskDAO < DAO
  db.create_table(:tasks) do
    primary_key :id
    String :name
    String :due_on, index: true
    Integer :created_at
    index [:name, :due_on], unique: true
  end unless db.table_exists?(:tasks)
  
  class << self
    def find_by_name_and_due_on(name, due_on)
      db[:tasks].filter(:name.ilike(name)).filter(due_on: due_on).first
    end
    
    def save(task)
      db[:tasks].insert name: task.name, due_on: task.due_on, 
                        created_at: task.created_at.to_i
    end
    
    def find_all_by_due_on(due_date)
      db[:tasks].filter(due_on: due_date).order(:id).all
    end
    
    def delete_all
      db[:tasks].delete
    end
  end
end
