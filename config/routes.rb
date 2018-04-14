Rails.application.routes.draw do
  resources :stories
  root to: 'home#index'
end
