#server "10.10.1.100", :app, :web, :db, :primary => true
server "54.238.130.206", :web
#server "10.10.1.106", :web
set :deploy_to, "/srv/www/onlynet.biz"
set :rails_env, "production"
set :thin_config_file, "./config/thin.yml"
set :thin_pid_file, "#{shared_path}/pids/thin.pid"