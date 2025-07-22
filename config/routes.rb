# frozen_string_literal: true

Rails.application.routes.draw do
  # Auth
  devise_for :users
  authenticated :user do
    root to: 'applications#index', as: :authenticated_root
  end
  scope ActiveStorage.routes_prefix do
    # Only authenticated users can access active storage blobs
    get '/blobs/redirect/:signed_id/*filename' => 'secure_blobs#show'
  end

  ## App routes
  resources :clients, only: %i[edit update]
  resources :applications do
    member do
      delete :remove_attachment
    end
  end
  get 'building_surveyor_search' => 'search#building_surveyor_search', as: :building_surveyor_search
  resources :reports, only: [:index] do
    collection do
      get :download
    end
  end
  get 'application_types/edit', to: 'application_types#edit'
  put 'application_types/update_all', to: 'application_types#update_all'

  ## Health routes
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'check_recent_backup' => 'health#check_recent_backup'
  get 'fail' => 'health#fail' # For testing exception notifications

  root to: redirect('/users/sign_in')
end
