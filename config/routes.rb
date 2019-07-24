Rails.application.routes.draw do
  root "static_pages#home"
  
  get "/signup", to: "users#new"
  resources :users, only: %i(show new create)
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :account_activations, only: :edit
  resources :sub_forums, except: :edit
  resources :members, only: %i(create destroy)
  resources :password_resets, only: %i(new create edit update)
end
