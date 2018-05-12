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

  resources :users, path: "/", only: [:show], param: :username do
    resource :relationship, only: [:create, :destroy], module: :users
  end

  root to: "home#index"
end
