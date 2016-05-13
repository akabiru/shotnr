Rails.application.routes.draw do
  root 'original_urls#index'

  post 'original_urls' => 'original_urls#create', defaults: { format: 'js' }

  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/search/:vanity_string_' => 'short_urls#check_vanity_string', constraints: { format: 'json' }

  resources :original_urls
  resources :short_urls

  get '/:vanity_string' => 'original_urls#redirect_to_original_url'

end
