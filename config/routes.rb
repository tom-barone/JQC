Rails.application.routes.draw do
  resources :suburbs
  resources :stages
  resources :invoices
  resources :councils
  resources :clients
  resources :applications
  resources :application_uploads
  resources :application_types
  resources :application_additional_informations
  root 'applications#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
