default_run_options[:pty] = true

set :application, "inaturalist"
set :domain,      "inat.nzbrn.org.nz"
default_run_options[:pty] = true
set :repository,  "git@github.com:nzbrn/inaturalist.git"
set :scm, "git"
set :user, "egressive"
set :branch, "master"
set :deploy_via, :remote_cache

# Don't use sudo, execute all commands as inaturalist
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "~/test_cap_deploy/#{application}"
stage = fetch(:stage, 'production')
case stage
when 'staging'
  set :deploy_to, "/home/#{user}/rails/#{application}/staging/"
  set :rails_env, 'staging'
else
  set :deploy_to, "/home/#{user}/rails/#{application}/production/"
  set :rails_env, 'production'
end

set :inat_config_shared_path, "#{deploy_to}shared/config"

set :num_listeners, 1

role :app, domain
role :web, domain
role :db,  domain, :primary => true



