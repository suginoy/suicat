Suicat::Application.routes.draw do
  root to: 'home#index'
  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy'
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
end
