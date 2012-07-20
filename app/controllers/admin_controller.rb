class AdminController < ApplicationController
  http_basic_authenticate_with :name => Rails.configuration.auth_username, :password => Rails.configuration.auth_password

  def home
    @users = User.order("created_at DESC")
  end

  def invite_user
    user = User.find_by_email params[:email]
    if user.nil?
      render :text => "false", :status => 400
      return
    end 

    begin
      BetaMailer.invite_mail(user).deliver
      user.state = User::STATES[:invited]
      user.save
      render :text => "true"
      #TODO ERRORS
    rescue
      render :text => "false", :status => 400
    end
  end

end
