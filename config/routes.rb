Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  get '/signup',   to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#auth_failure'

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts do
    resources :comments,          only: [:create, :update, :destroy]
    resources :likes,             only: [:create, :destroy]
    collection do
      get :categories, :search
    end
  end
  resources :relationships,       only: [:create, :destroy]
  resources :notifications,       only: :index
end
