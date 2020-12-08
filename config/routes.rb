Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'posts#index'
  
  devise_for :users
  resource :user, only: :show, as: :profile
  resources :users, only: :show

  resources :posts
  resources :likes, only: [:create, :destroy]

  get 'about', to: 'application#about'
end
