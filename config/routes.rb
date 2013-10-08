Suicat::Application.routes.draw do
  root to: 'home#index'
  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy'
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :api do
    post 'users/:user_id/histories', to: 'users/histories#create', as: 'user_histories'
  end
end
