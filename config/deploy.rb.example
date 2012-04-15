set :application, "egressive"
set :domain,      "inaturalist"
set :repository,  "git://github.com/nzbrn/inaturalist.git"
set :scm, "git"
set :user, "egressive"
set :branch, "master"
set :deploy_via, :remote_cache
set :default_environment, {
    'PATH' => "/var/lib/gems/1.8/bin/:$PATH"
}
set :inat_config_shared_path, "/home/#{application}/config/"
default_run_options[:pty] = true
set :deploy_to, "/home/#{application}/deployment/production/"
role :app, domain
role :web, domain
role :db,  domain, :primary => true
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
namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && #{sudo} /var/lib/gems/1.8/bin/bundle install --without test"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end

# HOOKS
after "deploy:update_code" do
  bundler.bundle_new_release
  # ...
end
after "deploy:update_code" do
  symlink_config
  symlink_db_config
  symlink_gmap_api_key
  symlink_sphinx_config
  symlink_s3_config
  symlink_newrelic_config # temp
  symlink_attachments
  #symlink_cache
  # symlink_observation_tiles
  #symlink_sphinx
  #sphinx_configure
end
desc "Create a symlink to a copy of config.yml that is outside the repos."
task :symlink_config, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/config.yml #{latest_release}/config/config.yml"
  run "ln -s #{inat_config_shared_path}/settings.yml #{latest_release}/config/settings.yml"
end

desc "Create a symlink to a copy of database.yml that is outside the repos."
task :symlink_db_config, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/database.yml #{latest_release}/config/database.yml"
end

desc "Create a symlink to domain, dev.domain or test.domain gmap_api_key.yml file"
task :symlink_gmap_api_key, :hosts => "#{domain}" do
  stage = fetch(:stage, 'production')
  case stage
  when 'test'
    run "ln -s #{inat_config_shared_path}/test_gmaps_api_key.yml #{latest_release}/config/gmaps_api_key.yml"
  when 'dev', 'development'
    run "ln -s #{inat_config_shared_path}/dev_gmaps_api_key.yml #{latest_release}/config/gmaps_api_key.yml"
  else
    run "ln -s #{inat_config_shared_path}/production_gmaps_api_key.yml #{latest_release}/config/gmaps_api_key.yml"
  end
end

desc "Create a symlink to a copy of smtp.yml that is outside the repos."
task :symlink_smtp_config, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/smtp.yml #{latest_release}/config/smtp.yml"
end

desc "Create a symlink to a copy of sphinx.yml that is outside the repos."
task :symlink_sphinx_config, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/sphinx.yml #{latest_release}/config/sphinx.yml"
end

desc "Create a symlink to a copy of s3.yml that is outside the repos."
task :symlink_s3_config, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/s3.yml #{latest_release}/config/s3.yml"
end

# temp
desc "Create a symlink to a copy of newrelic.yml that is outside the repos."
task :symlink_newrelic_config, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/newrelic.yml #{latest_release}/config/newrelic.yml"
end

desc "Symlink to the common attachments dir"
task :symlink_attachments, :hosts => "#{domain}" do
  run "ln -s #{shared_path}/system/attachments #{latest_release}/public/attachments"
end
=begin
desc "Symlink to the common cache dir"
task :symlink_cache, :hosts => "#{domain}" do
  run "ln -s #{shared_path}/system/cache #{latest_release}/cache"
  run "ln -s #{shared_path}/system/page_cache/observations #{latest_release}/public/observations"
  run "ln -s #{shared_path}/system/page_cache/taxa #{latest_release}/public/taxa"
  run "ln -s #{shared_path}/system/page_cache/places #{latest_release}/public/places"
  run "ln -s #{shared_path}/system/page_cache/lists #{latest_release}/public/lists"
end
=end
desc "Symlink the path to tilelite"
task :symlink_observation_tiles, :hosts => "#{domain}" do
  run "ln -s #{inat_config_shared_path}/tilelite/public #{shared_path}/system/page_cache/observations/tiles"
end

desc "Clear the cache directories"
task :clear_cache, :hosts => "#{domain}" do
  run "rm -rf #{shared_path}/system/cache/*"
  run "rm -rf #{shared_path}/system/page_cache/observations/*"
end

# DelayedJob
namespace :delayed_job do
  desc "Start delayed_job process" 
  task :start, :roles => :app do
    run "cd #{current_path}; script/delayed_job start production" 
  end

  desc "Stop delayed_job process" 
  task :stop, :roles => :app do
    run "cd #{current_path}; script/delayed_job stop production" 
  end

  desc "Restart delayed_job process" 
  task :restart, :roles => :app do
    run "cd #{current_path}; script/delayed_job restart production" 
  end
end

after "deploy:start", "delayed_job:start" 
after "deploy:stop", "delayed_job:stop" 
after "deploy:restart", "delayed_job:restart"
