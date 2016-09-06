Rails.application.routes.draw do
  root 'admin/dashboard#index'
  mount QyWechat::Engine, at: "/"
  authenticate :admin, lambda {|u| u.present? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
      get :get_sum
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
    resources :interfaces do
      resources :api_users, only: [:index, :new, :create, :destroy]
    end
    resources :dashboard
  end

  resources :oauths, only: [:index]
  #日报表

  #index : 服务器(第三个菜单)，show：服务器详情（含诊断指向诊断结果）
  resources :machine_details, only: [:index, :show]

  resources :weather do
     collection do
       get 'port'    #调用接口
       get 'meteorologic'    #气象数据
       get 'result'    #诊断结果
     end
   end

   #报表页
   resources :reports, only: [:index, :show] do
     member do
       get :daily
       get :week
       get :month
     end
     collection do
      get :week_index
      get :month_index
      get 'week_show'
      get 'month_show'
    end
   end

   resources :customers, shallow: true do
     resources :api_users, only: [:index, :show] do
       collection do
         get :daily_index
         get :week_index
         get :month_index
         get :daily
         get :week
         get :month
       end
     end
   end

   resources :alarms, only: [:index, :show] do
     collection do
       get :active
     end
   end

  resource :monitor, only: [:show] do
    collection do
      get :stations
      get :machines
      get :counts
      get :interfaces
      get :task_logs
    end
  end

end
