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

  def import_emails
    emailString = params[:emails]
    emails = emailString.split(/[,;\s]+/)
    total = 0
    alreadyImported = 0

    emails.each do |email|
      trimmed = email.strip
      user = User.new
      user.email = trimmed
      saved = user.save
     if saved
       total += 1
     else 
       user = User.find_by_email trimmed
       alreadyImported += 1 if !user.nil? 
     end
    end

    render :text => "Imported " + total.to_s + " of " + emails.length.to_s + ". " + alreadyImported.to_s + " previously imported. " + (emails.length - total - alreadyImported).to_s + " errors." 
  end

  def export_emails
    csv = User.all.collect {|u| u.email}.join(", ")
    render :text => csv
  end

end
