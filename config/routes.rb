Rails.application.routes.draw do
  root 'original_urls#index'
  resources :original_urls
  resources :short_urls

  get '/short_urls/:id/edit' => 'short_urls#edit', defaults: { format: 'js' }
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/search/:vanity_string_' => 'short_urls#check_vanity_string', constraints: { format: 'json' }
  get '/:vanity_string' => 'original_urls#redirect_to_original_url'

end
