Rails.application.routes.draw do
  get "login", to: "sessions#new", as: "login"   # Show login form
  post "login", to: "sessions#create" # Handle login form submission
  delete "logout", to: "sessions#destroy", as: "logout"# Logout action
  get "signup", to: "users#new", as: "signup"
  post "signup", to: "users#create"
  root to: "sessions#new"
end
