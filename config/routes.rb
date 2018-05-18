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
  resource :avatars, only: [:update], controller: "user/avatars"

  resources :pods, only: [:create] do
    resource :like, only: [:create, :destroy], module: :pods
  end

  resources :users, path: "/", only: [:show], param: :username do
    scope module: :users do
      resource :relationship, only: [:create, :destroy]
      resource :followers, only: [:show]
      resource :following, only: [:show], controller: "following"
    end
  end

  authenticated :user do
    root "home#show"
  end

  root to: "welcome#index"
end
