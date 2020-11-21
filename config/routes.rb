Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :groups
  resources :lists
  resources :tasks
end
