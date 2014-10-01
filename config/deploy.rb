require "rvm/capistrano"
require 'bundler/capistrano'
require 'capistrano_colors'
require 'capistrano-unicorn'
#require "whenever/capistrano"

set :stages, %w(production)
set :default_stage, 'production'
set(:rails_env) { fetch :production }
require 'capistrano/ext/multistage'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "liveseasonal"

set :keep_releases, 5
set :scm, :git
set :repository,  'git@github.com:ssuprunenko/liveseasonal.git'
set :branch, "master"

set :deploy_via, :remote_cache
set :use_sudo, false

set :shared_files,  %w(config/database.yml)

#set :unicorn_conf, "#{deploy_to}/current/config/unicorn/#{unicorn_env}.rb"
#set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

#role :web, domain                         # Your HTTP server, Apache/etc
#role :app, domain                          # This may be the same as your `Web` server
#role :db, domain, :primary => true # This is where Rails migrations will run

set :max_asset_age, 2 ## Set asset age in minutes to test modified date against.

# cap do_rake TASK=about
namespace :do_rake do
  desc "remote rake task"
  task :default do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake #{ENV['TASK']}"
  end
end

namespace :deploy do
  #task :restart do
  #  run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  #end
  #task :start do
  #  run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  #end
  #task :stop do
  #  run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  #end

  desc "Maintains a shared uploads directory between releases"
  task :symlink_shared do
    run "mkdir -p #{shared_path}/uploads && ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  task :update_shared_symlinks do
    shared_files.each do |path|
      run "rm -rf #{File.join(release_path, path)}"
      run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
    end
  end

  task :run_migrations do
    #run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:migrate"
    from = source.next_revision(current_revision)
    if capture("cd #{latest_release} && #{source.local.log(from)} db/migrate | wc -l").to_i > 0
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
      logger.info "New migrations added - running migrations."
    else
      logger.info "Skipping migrations - there are not any new."
    end
  end

  namespace :assets do
    desc "Figure out modified assets."
    task :determine_modified_assets, :except => { :no_release => true } do
      set :all_assets_path, %w[app lib vendor].map { |folder| "#{latest_release}/#{folder}/assets" }.join(' ')
      set :updated_assets, capture("find #{all_assets_path} -type d -name .git -prune -o -mmin -#{max_asset_age} -type f -print", :except => { :no_release => true }).split
    end

    desc "Remove callback for asset precompiling unless assets were updated in most recent git commit."
    task :conditionally_precompile, :except => { :no_release => true } do
      if updated_assets.empty?
        callback = callbacks[:after].find{|c| c.source == "deploy:assets:precompile" }
        callbacks[:after].delete(callback)
        logger.info("Skipping asset precompiling, no updated assets.")
      else
        logger.info("#{updated_assets.length} updated assets. Will precompile.")
      end
    end
  end
end

after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
after "deploy:finalize_update", "deploy:assets:determine_modified_assets", "deploy:assets:conditionally_precompile"
after 'deploy:update_code', 'deploy:run_migrations'
#after 'deploy:update_code', 'dragonfly:symlink'
after  "deploy:finalize_update", "deploy:update_shared_symlinks"
after "deploy:restart", "deploy:cleanup"

  require './config/boot'
  # require 'airbrake/capistrano'
