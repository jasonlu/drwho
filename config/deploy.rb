# config valid only for Capistrano 3.1
lock '3.2.1'

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

namespace :deploy do

  desc 'Create symlink'
  task :create_symlink do
    on roles(:app) do |host|
      execute :ln, "-s #{fetch :static_shares}/config/database.yml #{fetch :release_path}/config/database.yml"
      execute :ln, "-s #{fetch :static_shares}/config/initializers/secret_token.rb #{fetch :release_path}/config/initializers/secret_token.rb"
      within "#{fetch :release_path}" do
        execute :rm, "-Rf #{fetch :release_path}/public"
        execute :ln, "-s #{fetch :static_shares}/public #{fetch :release_path}/public"

        execute :rm, "-Rf #{fetch :release_path}/log"
        execute :ln, "-s #{fetch :shared_path}/log #{fetch :release_path}/log"

        execute :rm, "-Rf #{fetch :release_path}/app/models"
        execute :ln, "-s #{fetch :models_path} #{fetch :release_path}/app/models"
        
      end      
    end
  end

  desc "bundle_install"
  task :bundle_install do
    on roles(:app) do |host|
      within "#{fetch :deploy_to}/current" do
        execute :bundle, "install"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Compile Assets'
  task :compile_assets do
    on roles(:app) do |host|
      within "#{fetch :release_path}" do
        execute :bundle, "exec rake assets:precompile"
      end
    end
  end

  after :published, :create_symlink do
    Rake::Task["deploy:bundle_install"].invoke
    Rake::Task["deploy:compile_assets"].invoke
    Rake::Task["deploy:restart"].invoke
    
    #deploy.bundle_install
    #deploy.restart
  end

  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
