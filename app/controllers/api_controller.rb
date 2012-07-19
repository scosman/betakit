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

end
