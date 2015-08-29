
# require "delayed/recipes"
set :rails_env, "production" #added for delayed job

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'EventApp'
#set :repo_url, 'git@example.com:me/my_repo.git' 
set :repo_url, 'git@bitbucket.org:vacationlabs/lakshadeep-event-project.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp



# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

set :deploy_to, '/home/lakshadeep/rails/eventapp/'             #for passenger

# set :deploy_to, '/home/lakshadeep/unicorn/eventapp/'             #for unicorn


# Default value for :scm is :git
# set :scm, :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty
 set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true
 set :pty, true


# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')


# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
# set :linked_dirs, %w{tmp/pids}
# set :delayed_job_server_role, :worker

# after "deploy:stop",    "delayed_job:stop"
# after "deploy:start",   "delayed_job:start"
# after "deploy:restart", "delayed_job:restart"

# set :delayed_job_args, "-n 2"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# set :delayed_job_queues, ['mailer','tracking']

# Specify different pools
# You can use this option multiple times to start different numbers of workers for different queues.
# default value: nil


set :delayed_job_pools, {
    :mailer => 2,
    :tracking => 1,
    :* => 2
}

# Set the roles where the delayed_job process should be started
# default value: :app
# set :delayed_job_roles, [:app, :background]

set :delayed_job_bin_path, 'script'






namespace :deploy do

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     within release_path do
  #       # execute :rake, 'cache:clear'
  #       execute :rake, 'create:db'

  #     end
  #   end
  # end

  # task :restart do                       #only for unicorn
  #   invoke 'unicorn:reload'
  # end

end


after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end


