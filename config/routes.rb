# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :clients, only: %i[edit update]
  resources :applications do
    member do
      delete :remove_attachment
    end
  end

  scope ActiveStorage.routes_prefix do
    # Make it so only authenticated users can access active storage blobs
    get '/blobs/redirect/:signed_id/*filename' => 'secure_blobs#show'
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'check_recent_backup' => 'health#check_recent_backup'
  get 'fail' => 'health#fail'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get 'building_surveyor_search' => 'search#building_surveyor_search', as: :building_surveyor_search

  resources :reports, only: [:index] do
    collection do
      get :download
    end
  end

  # Test routes to check emails are sent on exceptions
  # TODO add this to a /health endpoint
  get 'fail' => 'testing#fail' unless Rails.env.production?

  get 'application_types/edit', to: 'application_types#edit'
  put 'application_types/update_all', to: 'application_types#update_all'

  authenticated :user do
    # Define authenticated routes here
    root to: 'applications#index', as: :authenticated_root
  end

  # Defines the root path route ("/")
  root to: redirect('/users/sign_in')
end
# rubocop:enable Metrics/BlockLength
