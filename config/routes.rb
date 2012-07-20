Betakit::Application.routes.draw do

  match '/' => 'admin#home'

  match '/api/request_invite' => 'api#request_invite'
  match '/api/invite_user' => 'admin#invite_user'
  match '/api/import_emails' => 'admin#import_emails'
  match '/api/export_emails' => 'admin#export_emails'
  match '/api/increment_stat' => 'api#increment_stat'

end
