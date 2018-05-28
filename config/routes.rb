Rails.application.routes.draw do
  devise_for :users, path: "sudo", controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions",
    unlocks: "users/unlocks"
  }

  resources :stories, except: [:create] do
    post "preview", on: :collection
    post "publish", on: :member
    delete "unpublish", on: :member
  end

  resources :pods, only: [:create] do
    resource :like, only: [:create, :destroy], module: :pods
    resources :comments, only: [:create], module: :pods
    resource :reaction, only: [:create, :destroy], module: :pods
  end

  resources :comments, only: [] do
    resource :like, only: [:create, :destroy], module: :comments
  end

  namespace :me do
    resource :avatar, only: [:create, :update, :edit]
  end

  scope ":username", as: :user, module: :profiles do
    resource :followers, only: [:show]
    resource :following, only: [:show], controller: :following
    resource :relationship, only: [:create, :destroy]
    resources :pods, only: [:show]
    root "profile#show", as: :profile
  end

  authenticated :user do
    root "home#show"
  end

  root to: "welcome#index"
end
