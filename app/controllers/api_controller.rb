class ApiController < ApplicationController

  def request_invite
    existingUser = User.find_by_email params[:email]
    if !existingUser.nil?
      render :json =>  {:referralCode => existingUser.referral_code}.to_json, :callback => params[:callback]
      return
    end

    referer = User.find_by_referral_code params[:referral_code]
    email = params[:email]
    user = User.new
    user.email = email
    user.referer = referer
    success = user.save

    if success
      render :json =>  {:referralCode => user.referral_code}.to_json, :callback => params[:callback]
    else
      render :json =>  {:error => "Could not save email"}.to_json, :callback => params[:callback]
    end
  end

  def increment_stat
    user = User.find_by_email params[:email]

    if user.nil?
      render :json =>  {:error => "No User"}.to_json, :callback => params[:callback]
    end

    success = user.increment_stat(params[:stat])
    
    if !success
      render :json =>  {:error => "could not save"}.to_json, :callback => params[:callback]
    end

    render :json =>  {:status => "OK"}.to_json, :callback => params[:callback]
  end

end
