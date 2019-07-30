Rails.application.routes.draw do
  root "static_pages#home"
  
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(show new create update)
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :account_activations, only: :edit
  resources :sub_forums
  resources :password_resets, only: %i(new create edit update)
  resources :sub_forums
  resources :members, only: %i(create destroy update)
  resources :password_resets, only: %i(new create edit update)
  resources :members, only: %i(create destroy)
  get "/submit", to: "posts#new"
  post "/submit", to: "posts#create"
  resources :posts, only: %i(show update)
  post "/posts/:id", to: "post_interactions#update"
  get "/search", to: "searchs#new"
  get "/users/:id/created_sub_forums",
    to: "users#show_created_sub_forums", as: "created_sub_forums"
end
