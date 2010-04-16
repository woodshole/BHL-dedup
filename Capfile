load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  ##nogroup for debian
  desc "Chown the whole thing to Nobody..."
  task :chown_public do 
    # Attachment_fu created a public/picklists directory, which freaked out Passenger
    run "mkdir #{release_path}/public/picklist_uploads"
    run "rm -rf #{release_path}/public/picklists"
    
    run "chown -R nobody:nogroup #{release_path}"
  end
  
  # This is necessary if you want to use mod_rewrite
  desc "Removes the .htaccess file from /public"
  task :remove_htaccess do
    run "rm -f #{release_path}/public/.htaccess"
  end
end

desc "Link in the production database.yml"
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

namespace :deploy do
  after "deploy:update_code", :link_production_db, 'passenger:chown_public'
  
  
  desc <<-DESC
  Restart the Passenger processes on the app server by calling passenger:restart.
  DESC
  task :restart, :roles => :app do
    passenger.restart
  end

  desc <<-DESC
  Doesn't do anything to Passenger
  DESC
  task :start, :roles => :app do
  end
  
  desc <<-DESC
  Doesn't do anything to Passenger
  DESC
  task :stop, :roles => :app do
  end
end
