Rails.application.routes.draw do
  get 'unity_storage_disk/show'
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
  post 'reset_all', to: 'game_projects#reset_all'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get '/rails/active_storage/disk/:encoded_key/*filename' => 'unity_storage_disk#show'

  # Defines the root path route ("/")
  root "game_projects#index"
end
