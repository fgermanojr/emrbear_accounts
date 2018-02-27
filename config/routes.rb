Rails.application.routes.draw do
  root 'contents#index'

  get 'users', to: 'users#index'

  get '/trials/user_create', to: 'trials#user_create' # PUTS UP USER CREATE FORM
  post '/user/create', to: 'users#create'  # creates user

  get '/login/new', to: 'trials#user_login' # puts up login form # was authentication#new
  post '/login', to: 'authentication#login' # process login form

  get '/login/edit', to: 'trials#user_verify' # puts up token form # use /trials/user_verify
  post '/login/update', to: 'authentication#update' # process token

  match '/logout', to: 'authentication#logout', via: [:get, :post]

  get '/emails/new', to: 'emails#new'
  post '/emails/send_email', to: 'emails#send_ems'

  # set trials below up on users
  get '/trials/some', to: 'trials#some_partial' # DEBUG

  get '/trials/user_login', to: 'trials#user_login'
  get '/trials/user_logout', to: 'trials#user_logout'
  get '/trials/user_verify', to: 'trials#user_verify'

  get '/accounts/new', to: 'accounts#new'
  post '/accounts/create', to: 'accounts#create'
  post '/accounts/select', to: 'accounts#select'
  post '/accounts/invite', to: 'accounts#invite'
  get '/accounts', to: 'accounts#index'

  get '/contents/new', to: 'contents#new'
  get '/contents/create', to: 'contents#create'

  # get '/user/login', to: 'users#login'
  # get '/user/logout', to: 'users#logout'

  # get '/user/verify', to: 'users#verify'
  # get 'accounts/new', to: 'accounts#new'
  # post 'accounts/create', to: 'accounts#create'
  # post 'accounts/invite', to: 'accounts#invite'
  # post 'accounts/select', to: 'accounts#select'
  # get 'contents/new', to: 'contents#new'
  # post 'contents/create', to: 'contents#create'
  # get 'contents', to: 'contents#index'
end
