#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Drwho::Application.load_tasks

# namespace :db do
#   desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
#   task :rollback => :environment do
#     step = ENV['STEP'] ? ENV['STEP'].to_i : 1
#     version = ActiveRecord::Migrator.current_version - step
#     ActiveRecord::Migrator.migrate('db/migrate/', version)
#   end
# end

#require 'sunspot/solr/tasks'
