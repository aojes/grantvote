default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "grantvote"
set :use_sudo, false
set :user, "rails"

set :port, 32900
set :deploy_to, "/home/rails/#{application}"
set :deploy_via,    :remote_cache 
  
set :repository, "git@github.com:tefflox/grantvote.git"
set :shared_folders, %w{ assets }

set :scm, "git"
set :branch, "staging"

#set :git_shallow_clone, 1
#set :git_enable_submodules, 1
#set :scm_verbose, true

set :location, "67.23.26.17"

role :app, location
role :web, location
role :db,  location, :primary => true

require 'mongrel_cluster/recipes_2'
set :mongrel_servers, 2
set :mongrel_port,    5000
set :mongrel_environment, "production"
set :mongrel_conf, "/home/rails/grantvote/shared/config/mongrel_cluster.yml"
set :mongrel_user, "rails"
set :mongrel_group, "rails"

desc "Symlink shared folders, creating if not exist."
task :after_deploy do 
  sudo 
  shared_folders.each do |folder|
    link = "#{deploy_to}/current/public/#{folder}"
    target = "#{deploy_to}/shared/public/#{folder}/"
    run "if [ ! -d #{deploy_to}/shared/public ]; then  mkdir #{deploy_to}/shared/public; fi;"
    run "if [ ! -d #{target} ]; then  mkdir #{target}; fi;"
    run "rm -rf #{link}"
    run "ln -s #{target} #{link}"
  end
end

desc "The spinner task is used by deploy:cold to start the application"
task :spinner, :roles => :app do
 # send(run_method, ";cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::start")
   send(run_method, ";cd #{deploy_to}/current && mongrel_rails cluster::start")
end

desc "Restart the mongrel cluster"
task :restart, :roles => :app do
  send(run_method, ";cd #{deploy_to}/current && mongrel_rails cluster::restart")
end

desc "Create the mongrel configuration"
task :after_symlink do
  mongrel.cluster.configure
end


