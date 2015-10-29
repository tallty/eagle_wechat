Rails.application.routes.draw do

  mount QyWechat::Engine, at: "/"

  resources :machines do
    collection do
      post :base_hardware_info
      post :real_hardware_info
    end
  end
  
  resources :task_logs do
    collection do
      post :fetch
    end
  end

  resources :total_interfaces do
    collection do
      post :fetch
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  
  namespace :admin do
    resources :users
    resources :customers do
      resources :members 
      resources :machines
      resources :tasks
      resources :interfaces
    end
    
  end

  resources :oauths, only: [:index]
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

    #日报表

    #index : 服务器(第三个菜单)，show：服务器详情（含诊断指向诊断结果）
    resources :machine_details, only: [:index, :show]

    resources :weather do
       collection do
         get 'active'    #活跃告警
         get 'history'    #历史告警
         get 'port'    #调用接口
         get 'meteorologic'    #气象数据
         get 'result'    #诊断结果
       end
     end

     #报表页
     resources :reports, only: [:index, :show] do
        collection do
          get 'week'
          get 'week_show'
          get 'month'
          get 'month_show'
        end
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
