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
    user.user_agent = request.env['HTTP_USER_AGENT']
    success = user.save

    if success
      render :json =>  {:referralCode => user.referral_code}.to_json, :callback => params[:callback]
    else
      render :json =>  {:error => "Could not save email"}.to_json, :callback => params[:callback]
    end
  end

  # incriments user statistics
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

  def set_app_stat
    # check the signature
    raise "no signature" if params[:signature].nil?
    signedParams = request.query_string.first(request.query_string.rindex("&"))
    raise "signature must be last" unless "signature" == request.query_string.split("&").last.split("=")[0]
    raise "signature incorrect" unless params[:signature] == Digest::SHA1.hexdigest(signedParams + Rails.configuration.app_secret)

    stat = Statistic.new
    stat.time = params[:time].nil? ? Time.now : Time.at(params[:time])
    stat.name = params[:name]
    stat.value = Float(params[:value])
    stat.sample_size = Integer(params[:sample_size])
    stat.cohort_name = params[:cohort_name]
    stat.cohort_group = params[:cohort_group]
    stat.save!

    render :json =>  {:status => "OK"}.to_json
  end
end
