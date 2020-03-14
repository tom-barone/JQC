Rails.application.routes.draw do
  get 'application_search/index'

  root 'application_search#index'
end
