class BetaMailer < ActionMailer::Base
  default from: Rails.configuration.email_from_address 

  def invite_mail(user)
    @user = user
    welcomeMsg = Rails.configuration.email_invite_subject
    @inviteCode = Digest::SHA1.hexdigest(Rails.configuration.app_secret + user.email.downcase)[0,8]
    mail(:template_name => "invite_mail_" + Rails.env, :to => user.email, :subject => welcomeMsg)
  end
end
