set :rvm_ruby_string, '2.1.3'
set :rvm_type, :user
set :server_name, '178.62.216.169'
set :domain,      'liveseasonalexperiences.com'
set :user,        "deploy"
set :application, "liveseasonal"
set :deploy_to, "/home/#{user}/#{application}"

role :web, server_name                         # Your HTTP server, Apache/etc
role :app, server_name                          # This may be the same as your `Web` server
role :db, server_name, :primary => true # This is where Rails migrations will run
