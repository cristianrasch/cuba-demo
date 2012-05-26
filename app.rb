require "cuba"
require "rack/protection"
require "cuba/render"

Cuba.use Rack::Static, urls: %w(/stylesheets /images), root: "public"
Cuba.use Rack::Session::Cookie
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
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
    
    on "tasks" do
      login_required
      tasks = Task.due_today
      _render "tasks/index", {tasks: tasks}
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

