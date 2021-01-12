Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'posts#index'
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  resources :users, only: :show do
    get 'posts'
    get 'photos'
    get 'friends'
    get 'likes'
  end

  get 'profile/edit', to: 'users#edit_profile', as: :edit_profile
  patch 'profile/update', to: 'users#update_profile', as: :update_profile

  get '/friends', to: 'users#friends', as: :friends
  scope '/friends', as: :friends do
    get 'find', to: 'users#find_friends'
    get 'requests', to: 'users#friend_requests'
  end

  resources :posts do
    resources :comments, only: [:new, :edit]
  end

  resources :comments, only: [:create, :update, :destroy]
  get 'posts/:comment_id/new', to: 'comments#new_reply', as: 'new_reply'
  get 'posts/:comment_id/edit', to: 'comments#edit_reply', as: 'edit_reply'

  resources :likes, only: [:create, :destroy]

  resources :friend_requests, only: :create do
    member do
      post 'confirm'
      delete 'delete'
    end
  end

  delete 'unfriend', to: 'friendships#destroy', as: 'destroy_friendship'

  get 'about', to: 'static_pages#about'
  get 'search', to: 'static_pages#search'
end
