#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'resque/tasks'
require File.expand_path('../config/application', __FILE__)

StoreEngine::Application.load_tasks

# Model annotations.
#require 'annotate/tasks'
#ENV['position_in_class']   = "before"
#ENV['position_in_fixture'] = "before"
#ENV['show_indexes']        = "false"
#ENV['include_version']     = "false"
#ENV['exclude_tests']       = "false"
#ENV['exclude_fixtures']    = "false"
#ENV['skip_on_db_migrate']  = "false"

unless Rails.env.production?
  begin
    require 'rspec/core/rake_task'

    task :default => :spec

    RSpec::Core::RakeTask.new("spec:acceptance") do |t|
      t.rspec_opts = "--tag acceptance"

    end
  end
end
