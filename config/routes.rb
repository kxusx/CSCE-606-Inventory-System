Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, skip: [:registrations]

  devise_scope :user do
    get "signup", to: "users#new", as: "signup"
    get "users/sign_out", to: 'sessions#destroy'
    post "signup", to: "users#create"
    root to: "sessions#new", as: :unauthenticated_root
  end
  
  get "dashboard", to: "dashboard#index", as: "dashboard"

  resources :items
  resources :bins do
    collection do
      get "view", to: "bins#index", as: "view"
      get "add", to: "bins#new", as: "add"
    end
    member do
      delete "delete", to: "bins#destroy", as: "delete"
    end
  end
  get "delete-bins", to: "bins#delete_page", as: "delete_bins"

  # Log history route
  get "log-history", to: "logs#index", as: "log_history"

end
