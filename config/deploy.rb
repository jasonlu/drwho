# config valid only for Capistrano 3.1
lock '3.2.1'

# deploy:starting    - start a deployment, make sure everything is ready
# deploy:started     - started hook (for custom tasks)
# deploy:updating    - update server(s) with a new release
# deploy:updated     - updated hook
# deploy:publishing  - publish the new release
# deploy:published   - published hook
# deploy:finishing   - finish the deployment, clean up everything
# deploy:finished    - finished hook

set :application, 'drwho'
set :repo_url, "git@github.com:jasonlu/drwho.git"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :git_strategy, SubmoduleStrategy

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do

  desc 'Create symlink'
  task :create_symlink do
    on roles(:app) do |host|
      execute :ln, "-s #{fetch :static_shares}/config/database.yml #{fetch :release_path}/config/database.yml"
      execute :ln, "-s #{fetch :static_shares}/config/initializers/secret_token.admin.rb #{fetch :release_path}/config/initializers/secret_token.rb"
      set :shared_path, "#{fetch :release_path}/../../shared"
      within "#{fetch :shared_path}" do
        execute :mkdir, "-p ./log"
        execute :mkdir, "-p ./tmp"
        execute :mkdir, "-p ./pid"
        execute :mkdir, "-p ./assets"
      end

      within "#{fetch :release_path}" do
        execute :rm, "-Rf #{fetch :release_path}/public"
        execute :ln, "-s #{fetch :static_shares}/public #{fetch :release_path}/public"

        execute :rm, "-Rf #{fetch :release_path}/log"
        execute :ln, "-s #{fetch :shared_path}/log #{fetch :release_path}/log"

        execute :rm, "-Rf #{fetch :release_path}/tmp"
        execute :ln, "-s #{fetch :shared_path}/tmp #{fetch :release_path}/tmp"
        
      end      
    end
  end

  desc "bundle_install"
  task :bundle_install do
    on roles(:app) do |host|
      if release_path != ""
        path = release_path
      else
        path = "#{fetch :deploy_to}/current"
      end
      within path do
        execute :bundle, "install"
      end
    end
  end


  desc 'Compile Assets'
  task :compile_assets do
    on roles(:app) do |host|
      if release_path != ""
        path = release_path
      else
        path = "#{fetch :deploy_to}/current"
      end

      within path do
        execute :bundle, "exec rake assets:precompile"
      end
    end
  end

  desc 'Restart Thin'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      if release_path != ""
        path = release_path
      else
        path = "#{fetch :deploy_to}/current"
      end
      set :thin_pid_file, "#{path}/#{fetch :thin_pid_file}"

      within path do
        if remote_file_exists?(fetch :thin_pid_file)
          execute :bundle, "exec thin restart -O -C #{fetch :thin_config_file}"
        else
          execute :bundle, "exec thin start -O -C #{fetch :thin_config_file}"
        end
      end
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :published, :create_symlink do
    #Rake::Task["deploy:create_symlink"].invoke
    Rake::Task["deploy:bundle_install"].invoke
    Rake::Task["deploy:compile_assets"].invoke
    Rake::Task["deploy:restart"].invoke
    #deploy.bundle_install
    #deploy.restart
  end

  after :restart, :clear_cache do
    
  end

end

