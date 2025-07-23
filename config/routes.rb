Rails.application.routes.draw do
  root "libraries#index"

  # Main nested routes structure
  resources :libraries, only: [:index, :show] do
    resources :service_areas, only: [:index, :show] do
      resources :statistics, only: [:index, :show]
    end
  end

  # Optional standalone routes 
  resources :service_areas, only: [:index, :show]
  resources :statistics, only: [:index, :show]

  get "/about", to: "pages#about"

  # Optional health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Optional PWA setup (commented out)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end