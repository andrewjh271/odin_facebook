Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'posts#index'
  
  devise_for :users
  # resource :user, only: :show, as: :profile
  # get 'profile', to: 'users#show', as: :profile
  # scope '/profile' do
  #   get 'posts', to: 'users#posts', as: :profile_posts
  #   get 'friends', to: 'users#friends', as: :profile_friends
  #   get 'requests', to: 'users#requests', as: :profile_requests
  #   get 'find_friends', to: 'users#find_friends', as: :profile_find_friends
  # end

  resource :profile, only: [] do
    get 'posts'
    get 'photos'
    # get 'friends'
    # get 'requests'
    # get 'find_friends'
    get 'likes'
  end

  resources :friends, only: :index do
    collection do

      get 'requests'
      get 'find'
    end
  end

  resources :users, only: :show do
    get 'photos'
    get 'friends'
  end

  resources :posts
  resources :likes, only: [:create, :destroy]
  # get 'friends', to: 'friends#index'
  # get 'requests', to: 'friends#requests'
  # get 'find_friends', to: 'friends#find'

  resources :friend_requests, only: :create do
    member do
      post 'confirm'
      delete 'delete'
    end
  end

  delete 'unfriend', to: 'friendships#destroy'

  get 'about', to: 'application#about'
end
