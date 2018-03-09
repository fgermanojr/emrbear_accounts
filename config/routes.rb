Rails.application.routes.draw do
  root 'contents#index' # This is the main page, mostly

  get 'users', to: 'users#index'

  get '/users/new', to: 'users#new' # user create form
  post '/users/create', to: 'users#create'  # creates user

  get '/login/new', to: 'authentication#new' # login form
  post '/login', to: 'authentication#login' # process login form

  get '/login/edit', to: 'authentiction#edit' # token form
  post '/login/update', to: 'authentication#update' # process token

  get '/authentication/logout_form', to: 'authentication#logout_form'  # logout form
  match '/logout', to: 'authentication#logout', via: [:get, :post]

  get '/emails/new', to: 'emails#new'
  post '/emails/send_email', to: 'emails#send_ems'

  get '/trials/some', to: 'trials#some_partial' # test point

  get '/accounts', to: 'accounts#index'

  get '/accounts/new', to: 'accounts#new'
  post '/accounts/create', to: 'accounts#create'

  get '/accounts/select', to: 'accounts#select'
  post '/accounts/selected', to: 'accounts#selected'

  get '/accounts/invite', to: 'accounts#invite'
  post '/accounts/invited', to: 'accounts#invited'

  resources :contents
end
