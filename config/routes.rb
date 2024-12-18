Rails.application.routes.draw do
  namespace :android do
    resources :hot_patch_games
    get "service_test", to: "service_test#index"
    post "service_test/customize_game"
  end
  resources :published_games
  resources :conversations do
    member do
      get :continue
      post :send_message
    end
  end

  scope :conversations do
  end

  namespace :guests do
    get "dashboard/index"
  end

  namespace :users do
    get "dashboard/index"
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  get "gallary/:partial", to: "game_projects#gallary", as: "game_projects_gallary"
  resources :game_projects do
    member do
      post :chat_and_conclude
      post :build
      post :change_compile_type
      post :send_message
      post :reset_conversation
      post :request_game_spec

      get :show_log, to: "game_compiles#show_compile_log"
      get :download_log, to: "game_compiles#download_compile_log"
      post :destroy_game_compile, to: "game_compiles#destroy"
    end

    resources :dialog, only: %i[edit update]
  end

  scope :compiled_game do
    resources :webgl_game_compiles, only: %i[index show destroy]
    resources :html_game_compiles, only: %i[index destroy update] do
      member do
        post :serve
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  get "up" => "rails/health#show", as: :rails_health_check

  get "/rails/active_storage/disk/:encoded_key/*filename" => "unity_storage_disk#show"
  get "unity_storage_disk/show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  if Rails.env.development?
    post "developer_sign_in", to: "development#developer_sign_in"
    post "reset_all", to: "development#reset_all"
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Resque::Server.new, at: "/resque"
  end

  mount QuickPlayArcade::API => "/"

  mount PatchPlatform.new("/utils/game-patcher") => "/utils/game-patcher"

  # Defines the root path route ("/")
  # root "guests/dashboard#index"
  root "game_projects#index"
end
