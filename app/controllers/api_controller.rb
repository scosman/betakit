class ApiController < ApplicationController

  def request_invite
    email = params[:email]
    user = User.new
    user.email = email
    success = user.save

    if success
      render :text => "true"
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
