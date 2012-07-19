class AdminController < ApplicationController
  http_basic_authenticate_with :name => Rails.configuration.auth_username, :password => Rails.configuration.auth_password

  def home
    @users = User.all
  end

end
