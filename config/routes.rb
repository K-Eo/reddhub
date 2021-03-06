Rails.application.routes.draw do
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"
  get "disclaimer", to: "pages#disclaimer"
  get "noscript", to: "pages#noscript"

  namespace :finder, module: :finders do
    resources :users, only: [:index]
  end

  devise_for :users, path: "sudo", controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions",
    unlocks: "users/unlocks"
  }

  resources :pods, only: [:create, :destroy] do
    resources :attachments, only: [:create], module: :pods
    resources :comments, only: [:create], module: :pods
    resource :reaction, only: [:create, :destroy], module: :pods
  end

  resources :comments, only: [:destroy] do
    resource :reaction, only: [:create, :destroy], module: :comments
  end

  namespace :me do
    resource :avatar, only: [:create, :update, :edit]
    resource :cover, only: [:create]
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
