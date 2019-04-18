Rails.application.routes.draw do
  resources :conferences
  resources :users
  root 'application#hello'
end
