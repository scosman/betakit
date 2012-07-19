Betakit::Application.routes.draw do

  match '/' => 'admin#home'

  match '/api/request_invite' => 'api#request_invite'

end
