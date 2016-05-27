Rails.application.routes.draw do
  root 'links#new'
  resources :links

  get '/inactive' => 'links#inactive'
  get '/not_found' => 'links#not_found'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/search/:vanity_string_' => 'links#check_vanity_string', constraints: { format: 'json' }
  get '/:vanity_string' => 'links#redirect_to_actual_link'

end
