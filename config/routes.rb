Rails.application.routes.draw do
  get 'stadia/new'

  get 'seasons/new'

  get 'sessions/new'
  root 'static_pages#home'
  get 'help',       to: 'static_pages#help'
  get 'admin',      to: 'static_pages#admin'
  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :conferences
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :teams
  resources :seasons,             only: [:new, :create, :edit, :update]
  resources :stadia,              only: [:new, :create, :edit, :update]
  resources :players,             only: [:show]
end
