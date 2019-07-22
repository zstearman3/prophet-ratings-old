Rails.application.routes.draw do
  get 'stadia/new'

  get 'seasons/new'

  get 'sessions/new'
  root 'static_pages#home'
  get 'help',       to: 'static_pages#help'
  get 'admin',      to: 'static_pages#admin'
  get 'contact',    to: 'static_pages#contact'
  get 'dashboard',  to: 'static_pages#dashboard'
  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/rankings',  to: 'team_seasons#rankings', as: :rankings
  get '/team_shooting',      to: 'team_seasons#shooting',        as: :team_shooting
  get '/team_defense',       to: 'team_seasons#defense',         as: :team_defense
  get '/team_rebounding',    to: 'team_seasons#rebounding',      as: :team_rebounding
  get '/team_misc',          to: 'team_seasons#miscellaneous',   as: :team_misc
  get '/player_shooting',    to: 'player_seasons#shooting',      as: :player_shooting
  get '/player_advanced',    to: 'player_seasons#advanced',      as: :player_advanced
  get '/player_misc',        to: 'player_seasons#miscellaneous', as: :player_misc
  get '/season_predictions', to: 'predictions#statistics',       as: :predictions_statistics
  get '/blog_drafts',        to: 'blog_posts#drafts',            as: :blog_drafts
  get '/blog',               to: 'blog_posts#index',             as: :blog_posts
  get '/preseason',          to: 'teams#preseason',              as: :preseason
  get '/player_preseason',   to: 'player_seasons#preseason',     as: :player_preseason
  get '/404',                to: 'errors#not_found'
  get '/422',                to: 'errors#unacceptable'
  get '/500',                to: 'errors#internal_error'
  resources :conferences
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :teams
  resources :seasons,             only: [:new, :create, :edit, :update]
  resources :stadia,              only: [:new, :create, :edit, :update]
  resources :players,             only: [:show, :new, :create]
  resources :team_seasons,        only: [:index]
  resources :player_games,        only: [:index]
  resources :player_seasons,      only: [:edit, :update, :destroy]
  resources :games,               only: [:index, :show]
  resources :predictions,         only: [:index, :show]
  resources :blog_posts, :path => 'blog'
end
