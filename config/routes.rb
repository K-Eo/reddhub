Rails.application.routes.draw do
  devise_for :users, path: "sudo"
  resources :stories, except: [:index]
  resource :avatars, only: [:update], controller: "user/avatars"
  root to: "home#index"
end
