Rails.application.routes.draw do
  resources :game_projects do
    member do
      post :webgl_build
    end
  end

  scope :compiled_game do
    resources :webgl_game_compiles, only: [:index, :show, :destroy]
    resources :game_compiles
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "game_projects#index"
end
