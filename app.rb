require "date"
require "cuba"
require "rack/protection"
require "rack/csrf"
require "cuba/render"

Cuba.use Rack::Static, urls: %w(/stylesheets /images), root: "public"
Cuba.use Rack::ShowExceptions
Cuba.use Rack::Session::Cookie
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.use Rack::Csrf, raise: true
Cuba.plugin Cuba::Render

require_relative "models/user"
require_relative "models/task"
require_relative "lib/authenticated_system"
require_relative "lib/view_helper"
require_relative "lib/date_helper"
require_relative "lib/string_ext"

include AuthenticatedSystem
include ViewHelper
include DateHelper

Cuba.define do
  on get do
    on root do
      _render "index"
    end
    
    on "login" do
      _render "session/new"
    end
    
    on "seed" do
      login_required
      Task.delete_all
      system "cd #{File.dirname __FILE__} && rake db:seed"
      res.write "done."
    end
    
    on "tasks/(\\d{1,2})/(\\d{1,2})/(\\d{2,4})" do |day, month, year|
      login_required
      due_date = parse_date(day, month, year)
      
      if due_date
        tasks = Task.due_on(due_date)
        _render "tasks/index", {tasks: tasks, due_date: due_date}
      else
        res.redirect "/tasks"
      end
    end
    
    on "tasks" do
      login_required
      due_date = Date.today
      tasks = Task.due_on(due_date)
      _render "tasks/index", {tasks: tasks, due_date: due_date}
    end
  end
  
  on post do
    on "session" do
      on root do
        on param("email"), param("password") do |email, password|
          user = User.find_by_email(email)
          
          if user && user.authenticated_by?(password)
            session["email"] = email
            res.redirect "/tasks"
          else
            _render "session/new", {}, error: "Invalid email or password"
          end
        end
        
        on true do
          _render "session/new", {}, error: "Email or password missing"
        end
      end
      
      on "destroy" do
        session["email"] = nil
        res.redirect "/"
      end
    end
  end
end

