Rails.application.routes.draw do
  devise_for :users, path: "sudo"
  resources :stories, except: [:index, :update] do
    put "content", on: :member
    put "meta", on: :member
  end
  resource :avatars, only: [:update], controller: "user/avatars"
  root to: "home#index"
end
