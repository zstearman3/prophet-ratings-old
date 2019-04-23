Rails.application.routes.draw do
  root 'static_pages#home'
  get 'help',     to: 'static_pages#help'
  get '/signup',  to: 'users#new'
  post '/signup', to: 'users#create'
  resources :conferences
  resources :users
end
