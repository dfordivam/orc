set :bundle_cmd, '/opt/bitnami/ruby/bin/bundle'

require "bundler/capistrano"

# required on bitnami server as the bitnamiuser is not admin
set :use_sudo, false

set :application, "ORC Accomodation System"
set :repository,  "git://github.com/dfordivam/orc.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#

set :deploy_to, '/home/bitnami/servers/orc'
@orc_staging_server = '107.22.225.20'
server_root = '/home/bitnami/servers/orc'

role :web, @orc_staging_server  # Your HTTP server, Apache/etc
role :app, @orc_staging_server                          # This may be the same as your `Web` server
role :db,  @orc_staging_server, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


namespace :custom_code do
  task :config_database_yml, :roles => :app do
    run  "ln -nfs #{server_root}/shared/system/database.yml #{server_root}/current/config/database.yml"
  end
end

after "deploy:symlink", "custom_code:config_database_yml"

