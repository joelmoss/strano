#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Strano::Application.load_tasks

# Make spec the default task and replace the test task.
task :test => :spec
task :default => :spec