Rails.application.routes.draw do
  resources :uploadeds
  resources :stages
  resources :invoices
  resources :additional_infos
  resources :applications
  resources :councils
  resources :suburbs
  resources :application_types
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
