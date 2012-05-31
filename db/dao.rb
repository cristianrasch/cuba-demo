require "sequel"
require "logger"

class DAO
  class << self
    def db
      @db ||= connect
    end
    
  private
  
    def connect
      env = ENV["RACK_ENV"] || "development"
      if env == "test"
        @db = Sequel.sqlite
      else
        dir = File.dirname(__FILE__)
        env = ENV["RACK_ENV"] || "development"
        db_file = File.join(dir, "#{env}.db")
        @db = Sequel.sqlite(db_file)
        @db.loggers << Logger.new($stdout) if env == "development"
        @db
      end
    end
  end
end
