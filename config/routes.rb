Rails.application.routes.draw do
  root 'urls#index'
  resources :urls

  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/:short_url' => 'urls#redirect'

end
