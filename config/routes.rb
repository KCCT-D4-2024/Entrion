Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/hogefugahogefugahogehogefuga/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  get "info/admin" => "info#admin"
  get "users" => "users#show"
  get "users/exit" => "users#exit"
  get "users/enter" => "users#enter"
  get "users/enter_page" => "users#enter_page"
  get "users/user_qr" => "users#user_qr"
  post "users/score" => "users#score"
  get "info/stats", to: "info#stats"  # ポーリング用エンドポイント
  get "static_pages/linetrace"
  get "static_pages/ai"
  get "static_pages/led"
  get "static_pages/iot"
  get "static_pages/dflab"
  get "static_pages/game"
  get "static_pages/other"
  get "game_scores" => "game_scores#index"
  get "game_scores/new"
  post "game_scores/create" => "game_scores#create"
  resources :users, only: [ :show ] do
    member do
      get "confirm_exit", to: "users#confirm_exit"
      get "confirm_enter", to: "users#confirm_enter"
    end
  end
  root "tests#index"
  namespace :api do
    namespace :v1 do
      post "game_scores" => "game_scores#create"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  mount ActionCable.server => "/cable"
end
