Rails.application.routes.draw do
  resources :bookings
  resources :vehicles
   root "home#index"  # Ensure root is not redirecting infinitely
   resources :bookings, only: [:index, :show]


  resources :bookings do
    resource :payment, only: [:new, :create, :show] do
      get 'process_payment', on: :collection
    end
  end

  get 'home/index'
  devise_for :users

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end
  

  resources :vehicles do
    member do
      patch :toggle_availability
    end
  end

  resources :bookings do
    member do
      patch :accept
      patch :reject

    end
  end
  
  resources :bookings do
    member do
      get 'cancel'
    end
  end
  
  
  
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"


end
