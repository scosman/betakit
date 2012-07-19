# Load the rails application
require File.expand_path('../application', __FILE__)

# Auth Settings for development
Rails.configuration.auth_username = ENV["admin_username"]
Rails.configuration.auth_password = ENV["admin_password"]

# Initialize the rails application
Betakit::Application.initialize!
