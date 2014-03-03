require 'capistrano/ext/multistage'

set :user, "deploy"  # The server's user for deploys
set :application, "Drwho"
set :repository,  "git@github.com:jasonlu/drwho.git"
set :keep_release, 5
set :use_sudo, false

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
set :scm_passphrases, ""
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :stages, ["staging", "production"]
set :default_stage, "staging"


namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install  --without=test"
  end

end

# Generate an additional task to fire up the thin clusters

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end


namespace :deploy do
  task :start do
    #run "cd #{current_path} && bundle exec thin start -C #{release_path}/config/thin.yml"
    run "cd #{current_path} && bundle exec thin start -C #{thin_config_file}"
  end
  task :stop do
    #run "cd #{current_path} && bundle exec thin stop -C ./config/thin.yml"
    run "cd #{current_path} && bundle exec thin stop -C #{thin_config_file}"
  end
  task :restart, :roles => [:web, :app], :except => { :no_release => true } do
    if remote_file_exists?(thin_pid_file)
      run "cd #{current_path} && bundle exec thin restart -C #{thin_config_file}"
    else
      deploy.start
    end
    #run "cd #{current_path} && bundle exec thin restart -C ./config/thin.yml"
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "My setup here"
  task :setup do
    run "mkdir -p #{deploy_to} #{deploy_to}/releases #{deploy_to}/shared #{deploy_to}/shared/system #{deploy_to}/shared/log #{deploy_to}/shared/pids #{deploy_to}/shared/files #{deploy_to}/shared/temp #{deploy_to}/shared/uploads #{deploy_to}/shared/ckeditor_assets #{deploy_to}/shared/config"
    run "chmod g+w #{deploy_to} #{deploy_to}/releases #{deploy_to}/shared #{deploy_to}/shared/system #{deploy_to}/shared/log #{deploy_to}/shared/pids #{deploy_to}/shared/files #{deploy_to}/shared/temp #{deploy_to}/shared/uploads #{deploy_to}/shared/ckeditor_assets #{deploy_to}/shared/config"
    deploy.copy_files
  end

  task :copy_files do
    find_servers_for_task(current_task).each do |server|
      #run_locally "rsync -vr --exclude='.DS_Store' public/files #{user}@#{server.host}:#{shared_path}/"
      #run_locally "rsync -vr --exclude='.DS_Store' public/uploads #{user}@#{server.host}:#{shared_path}/"
      #run_locally "rsync -vr --exclude='.DS_Store' public/ckeditor_assets #{user}@#{server.host}:#{shared_path}/"
      run_locally "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{server.host}:#{shared_path}/config/"
      run_locally "rsync -vr --exclude='.DS_Store' config/initializers/secret_token.rb #{user}@#{server.host}:#{shared_path}/config/initializers/"
    end
  end

  desc "Migrate DB"
  task :migrate do
    run "cd #{current_path} && rake db:migrate RAILS_ENV=production"
  end

  desc "symlink shared files between releases"
  task :symlink_shared, :roles => [:app, :web] do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -nfs #{shared_path}/assets #{release_path}/assets"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/files #{release_path}/public/files"
    run "ln -nfs #{shared_path}/temp #{release_path}/public/temp"
    run "ln -nfs #{shared_path}/ckeditor_assets #{release_path}/public/ckeditor_assets"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/pid #{release_path}/tmp/pid"
    run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"

    #deploy.copy_files
        # run "ln -nfs #{shared_path}/log/production.log #{release_path}/log/production.log"
  end



  task :quick do
    deploy.update
    deploy.restart
  end

  task :warp10 do
    run_locally "git add . && git commit -am 'quick_deploy' && git push"
    deploy.quick
  end

  namespace :assets do
    task :precompile do
      run "cd #{current_path} && bundle exec rake assets:precompile"
    end
    task :clean do
      run "cd #{shared_path} && rm -Rf ./assets/*"
    end
  end

end


after "deploy:create_symlink", "deploy:symlink_shared"
before "deploy:symlink_shared", "deploy:copy_files"
after "deploy:symlink_shared", "deploy:assets:precompile"
before "deploy:assets:precompile", "bundle:install"
after "bundle:install", "deploy:migrate"
#before "deploy:restart", "bundle:install"







# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end