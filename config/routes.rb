Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, skip: [:registrations]

  devise_scope :user do
    get "signup", to: "users#new", as: "signup"
    post "signup", to: "users#create"

    authenticated :user do
      root to: "dashboard#index", as: :authenticated_root # After login, go to dashboard
    end

    unauthenticated do
      root to: "sessions#new", as: :unauthenticated_root # Before login, show login page
    end
  end

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
