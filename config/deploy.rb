require "bundler/capistrano"
require "rvm/capistrano"

set :rvm_ruby_string, "ruby-1.9.3-p194"
set :rvm_type, :system

set :application, "cuba-demo"

set :scm, :git
set :repository, "git@github.com:cristianrasch/cuba-demo.git"

set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"

role :app, "ec2"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end
