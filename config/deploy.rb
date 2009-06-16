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
set :branch, "master"

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
 send(run_method, ";cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::start")
 # send(run_method, ";cd #{deploy_to} && mongrel_rails cluster::start")
end

desc "Restart the mongrel cluster"
task :restart, :roles => :app do
 send(run_method, ";cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::restart")
 # send(run_method, ";cd #{deploy_to} && mongrel_rails cluster::restart")
end

desc "Create the mongrel configuration"
task :after_symlink do
  # mongrel.cluster.configure
  send(run_method, "cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::configure -e production -p 5000 -N 2 -c -a 127.0.0.1")
end

##
# ==============================================================================
# Fetches the production database on the server into the development database 
# 
# Assumes you have dbuser, dbhost, dbpassword, and application defined somewhere
# in your task. Modify as needed - database.yml is used for importing data, just
# not for exporting. Only supports MySQL.

desc "Load production data into development database"
task :import_remote_db do
  require 'yaml'
  
  database = YAML::load_file('config/database.yml')

  filename = "dump.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql"
  dbuser = "root"
  dbhost = "67.23.26.17"
  dbpassword = "vote32"
  application = "grantvote"
  dbtag = "staging"

  on_rollback do 
    delete "/tmp/#{filename}" 
    delete "/tmp/#{filename}.gz" 
  end
  
  cmd = "mysqldump -u #{dbuser} --password=#{dbpassword} #{application}_#{dbtag} > /tmp/#{filename}"
  puts "Dumping remote database"
  run(cmd) do |channel, stream, data|
    puts data
  end
  
  # compress the file on the server
  puts "Compressing remote data"
  run "gzip -9 /tmp/#{filename}"
  puts "Fetching remote data"
  get "/tmp/#{filename}.gz", "dump.sql.gz"
  
  # build the import command
  # no --password= needed if password is nil. 
  if database['development']['password'].nil?
    cmd = "mysql -u #{database['development']['username']} #{database['development']['database']} < dump.sql"
  else
    cmd = "mysql -u #{database['development']['username']} --password=#{database['development']['password']} #{database['development']['database']} < dump.sql"
  end
  
  # unzip the file. Can't use exec() for some reason so backticks will do
  puts "Uncompressing dump"
  `gzip -d dump.sql.gz`
  puts "Executing : #{cmd}"
  `#{cmd}`
  puts "Cleaning up"
  `rm -f dump.sql`

  puts "Be sure to run rake db:migrate to ensure your database schema is up to date!"
end

set :shared_host, "67.23.26.17"

desc "Mirrors the remote shared public directory with your local copy, doesn't download symlinks"
task :import_remote_assets do 
  if shared_host
    # Used friendly options so it's easier to read
    # I'm using rsync so that it only copies what it needs
    # Windows users you can use the download method within capistrano and pass recursive => true
    run_locally("rsync --recursive --times -e 'ssh -i /home/jess/.ssh/rails_grantvote -p 32900' --compress --human-readable --progress #{user}@#{shared_host}:#{shared_path}/public/assets/ public/assets/")
  else
    puts "Define a shared_host variable so I know where to get the files from."
  end  
end

