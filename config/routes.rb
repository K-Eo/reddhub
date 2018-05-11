Rails.application.routes.draw do
  devise_for :users, path: "sudo"
  resources :stories, except: [:create] do
    post "preview", on: :collection
    post "publish", on: :member
    delete "unpublish", on: :member
  end
  resource :avatars, only: [:update], controller: "user/avatars"

  resources :pods, only: [:create] do
    resource :like, only: [:create, :destroy], module: :pods
  end

  get ":username", to: "users#show", as: :user
  root to: "home#index"
end
