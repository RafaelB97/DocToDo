Rails.application.routes.draw do
  resources :tasks
  resources :lists
  root 'home#index'
  devise_for :users
  resources :groups
end
