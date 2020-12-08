Rails.application.routes.draw do
  resources :invitations
  root 'home#index'
  devise_for :users
  resources :groups
  resources :lists do
    member do
      patch :move
    end
  end
  resources :tasks do
    collection do
      post :createFromGroup
    end
    member do
      patch :move
    end
  end
end
