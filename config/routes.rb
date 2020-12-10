Rails.application.routes.draw do
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
  resources :invitations do
    collection do
      post :addUser
    end
    member do
      delete :destroyFromGroup
    end
  end
  resources :assigns
end
