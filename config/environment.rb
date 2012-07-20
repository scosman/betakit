# Load the rails application
require File.expand_path('../application', __FILE__)

# Auth Settings for production
Rails.configuration.auth_username = ENV["admin_username"]
Rails.configuration.auth_password = ENV["admin_password"]

# Email Settings for production
Rails.configuration.email_from_address = ENV["email_from_address"]
Rails.configuration.email_invite_subject = ENV["email_invite_subject"]

# SMTP settings
Rails.configuration.action_mailer.delivery_method = :smtp
Rails.configuration.action_mailer.smtp_settings = {
  :address              => (ENV["smtp_server"]||"smtp.gmail.com"),
  :port                 => (ENV["smtp_port"]||587),
  :domain               => (ENV["smtp_domain"]||'gmail.com'),
  :user_name            =>  ENV["smtp_user"],
  :password             =>  ENV["smtp_password"],
  :authentication       => (ENV["smpt_auth"]||'plain'),
  :enable_starttls_auto => true  }

Rails.configuration.action_mailer.raise_delivery_errors = true

# Initialize the rails application
Betakit::Application.initialize!
