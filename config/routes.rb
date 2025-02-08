Rails.application.routes.draw do
  resources :bins
  get "dashboard/index"
  get "login", to: "sessions#new", as: "login"   # Show login form
  post "login", to: "sessions#create" # Handle login form submission
  delete "logout", to: "sessions#destroy", as: "logout"# Logout action
  get "signup", to: "users#new", as: "signup"
  post "signup", to: "users#create"
  root to: "sessions#new"

  #dashboard route"
  get "dashboard", to: "dashboard#index", as: "dashboard"

  #Resources Routes, nested , items belong to bins 
  resources :bins do
    resources :items 
  end

  # standalone items will be route separetaly
  resources :items, only: [:index, :show, :create, :update, :destroy]


end
