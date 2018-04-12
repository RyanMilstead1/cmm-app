Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :wikis
  resources :charges, only: %i[new create destroy]
  resources :users, only: [:show]
  resources :collaborators, only: %i[create destroy]
  get 'collaborators/autocomplete', controller: :collaborators
end
