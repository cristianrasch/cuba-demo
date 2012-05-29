require "rake/testtask"
require "date"

require_relative "models/task"

Rake::TestTask.new do |t|
  ENV["RACK_ENV"] = "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end

namespace :db do
  desc 'Populate the db with seed data'
  task :seed do
    today = Date.today
    next_month = today.next_month
    (today..next_month).each do |due_date|
      how_many = rand(10)+1
      (1..how_many).each do |i|
        Task.new(name: "##{i} Task", due_on: due_date).save!
      end
    end
  end
end

task :default => :test
