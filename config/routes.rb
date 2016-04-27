Rails.application.routes.draw do
  root 'urls#index'
  resources :urls
  get '/:short_url' => 'urls#redirect'
  get '/auth/:provider/callback' => 'sessions#create'
end
