Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  resources :suburbs
  resources :stages
  resources :invoices
  resources :councils
  resources :clients
  resources :applications
  resources :application_uploads
  resources :application_types
  resources :application_additional_informations

  authenticated :user do
    root to: 'applications#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
