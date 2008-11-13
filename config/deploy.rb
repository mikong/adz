set :application, "adz"
set :domain,      "67.207.133.106"
set :user,        "mikong"
set :repository,  "ssh://git@67.207.133.106:2049/var/git/#{application}.git"
set :use_sudo,    false
set :deploy_to,   "/var/www/#{application}"
set :scm,         "git"
set :branch,      "master"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Prepare tmp folder for Passenger"
  task :prepare_tmp do
    run "mkdir #{release_path}/tmp"
  end
  
  desc "Symlink shared configs and folders on each release"
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    # tmp?
  end
  
  desc "Datamapper Upgrade"
  task :migrate do
    run "cd #{release_path}; rake db:autoupgrade MERB_ENV=production"
  end
end

after 'deploy:update_code', 'deploy:prepare_tmp'
after 'deploy:update_code', 'deploy:symlink_shared'