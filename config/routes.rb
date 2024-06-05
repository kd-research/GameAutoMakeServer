Rails.application.routes.draw do
  namespace :guests do
    get "dashboard/index"
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :users do
    get "dashboard/index"
  end

  resources :game_projects do
    member do
      post :webgl_build
    end
  end

  scope :compiled_game do
    resources :webgl_game_compiles, only: %i[index show destroy]
    resources :game_compiles
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "unity_storage_disk/show"

  get "up" => "rails/health#show", as: :rails_health_check
  get "/rails/active_storage/disk/:encoded_key/*filename" => "unity_storage_disk#show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope :admin do
    post "reset_all", to: "game_projects#reset_all"
  end

  # Defines the root path route ("/")
  root "guests/dashboard#index"
end
