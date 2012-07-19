#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

namespace :betakit do
  desc "calls request_invite api"
  task :request_invite, [:email] => :environment do |t, args|
    email = args[:email]
    user = User.new
    user.email = email
    saved = user.save
    if saved 
      puts "saved"
    else 
      puts "error"
    end
  end
end


Betakit::Application.load_tasks
