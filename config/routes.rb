Rails.application.routes.draw do
  devise_for :users, path: "sudo"
  resources :stories
  resource :avatars, only: [:update], controller: "user/avatars"
  root to: "stories#index"
end
