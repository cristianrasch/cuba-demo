require "date"

FactoryGirl.define do
  factory :task do
    sequence(:name) { |n| "##{n} Task" }
    sequence(:due_on) { |n| Date.today + n }
    created_at { Time.now.utc }
  end
end

