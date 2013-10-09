Suicat::Application.routes.draw do
  resources :users, only: :update
  resources :histories, only: :index

  namespace :api do
    get 'users/:user_id/histories', to: 'users/histories#index', as: 'user_histories'
    post 'users/:user_id/histories', to: 'users/histories#create', as: nil
  end

  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy'
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root to: 'histories#index', as: :user_root
  end
  root to: 'home#index'
end
