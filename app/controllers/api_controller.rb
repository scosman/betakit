class ApiController < ApplicationController

  def request_invite
    referer = User.find_by_referral_code params[:referral_code]

    email = params[:email]
    user = User.new
    user.email = email
    user.referer = referer
    success = user.save

    if success
      render :text => user.referral_code
    else
      render :text => "false", :status => 400
    end
  end

  def increment_stat
    user = User.find_by_email params[:email]

    if user.nil?
      render :text => "", :status => 400
    end

    success = user.increment_stat(params[:stat])
    
    if !success
      render :text => "", :status => 400
    end

    render :text => user.stats[params[:stat]].to_s
  end



end
