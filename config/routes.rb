Rails.application.routes.draw do

  mount QyWechat::Engine, at: "/"
  get 'welcome/index'

  resources :machines do
    collection do
      post :base_hardware_info
      post :real_hardware_info
    end
  end
  
  resources :task_logs do
    collection do
      post :run
    end
  end

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

  resources :oauths, only: [:index]
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
    resources :weather do
       collection do
         get 'active'
         get 'history'
         get 'port'
         get 'select_server'
         get 'server'
         get 'meteorologic'
         get 'statement'
         get 'server_x'
         get 'result'
       end
  #
  #     collection do
  #       get 'sold'
  #     end
     end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
