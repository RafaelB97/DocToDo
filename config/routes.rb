Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :groups
  resources :lists do
    member do
      patch :move
    end
  end
  resources :tasks
end
