default_run_options[:pty] = true

ssh_options[:forward_agent] = true


# be sure to change these
set :user, 'root'
set :domain, '67.23.26.17'
set :application, 'grantvote'
set :port, 3288

set :repository,  "git@github.com:tefflox/grantvote.git" 
set :deploy_to, "/var/web/staging/" 
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'staging'
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web
role :db, domain, :primary => true

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end
