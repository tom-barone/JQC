Rails.application.routes.draw do
  get 'application_search/index'

  resources :applications

  root 'application_search#index'
end
