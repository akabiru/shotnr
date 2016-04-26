Rails.application.routes.draw do
  root 'urls#index'
  resources :urls
  get '/:short_url' => 'urls#redirect'
end
