# frozen_string_literal: true

Rails.application.routes.draw do
  resources :applications
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Test routes to check emails are sent on exceptions
  # TODO add this to a /health endpoint
  get 'fail' => 'testing#fail' unless Rails.env.production?

  resources :applications, only: %i[index new create edit update destroy]

  get 'application_types/edit', to: 'application_types#edit'
  put 'application_types/update_all', to: 'application_types#update_all'

  authenticated :user do
    # Define authenticated routes here
    root to: 'applications#index', as: :authenticated_root
  end

  # Defines the root path route ("/")
  root to: redirect('/users/sign_in')
end
