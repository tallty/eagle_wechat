Rails.application.routes.draw do

  root to: 'welcome#index'

  resources :cpus
  resources :machines, only: [:create]
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  
  namespace :admin do
    resources :users
    resources :members
    resources :customers do
      resources :machines, shallow: true
    end
    
  end
end
