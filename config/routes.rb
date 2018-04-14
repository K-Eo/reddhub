Rails.application.routes.draw do
  devise_for :users, path: 'sudo'
  resources :stories
  root to: 'home#index'
end
