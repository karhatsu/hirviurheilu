ElkSports::Application.routes.draw do
  resource :home

  delete 'logout' => 'user_sessions#destroy', :as => :logout
  get 'login' => 'user_sessions#new', :as => :login
  resource :user_session

  resource :account, :controller => 'users'
  get 'register' => 'users#new', :as => :register
  resources :users
  get 'reset_password/:reset_hash/edit' => 'reset_passwords#edit'
  resource :reset_password
  resource :license
  resource :activation_key

  resource :mode

  resource :info
  resources :feedbacks

  get 'offline_vs_online' => 'offline_infos#comparison', :as => :offline_vs_online
  get 'offline_installation' => 'offline_infos#installation', :as => :offline_installation
  get 'offline_price' => 'offline_infos#price', :as => :offline_price
  
  post 'calculate_price' => 'prices#calculate_price', :as => :calculate_price
  resources :prices

  resources :races do
    resources :team_results
  end

  resources :series do
    resources :competitors
    resource :start_list
  end

  namespace :admin do
    resources :users do as_routes end
    resources :roles do as_routes end
    resources :races do as_routes end
    resources :clubs do as_routes end
    resources :sports do as_routes end
    resources :prices do as_routes end
    resources :default_series do as_routes end
    resources :default_age_groups do as_routes end
    root :to => "index#show"
  end

  namespace :official do
    resources :races do
      resources :competitors, :only => :create
      resources :clubs
      put 'correct_estimates' => 'correct_estimates#update', :as => :correct_estimates
      resources :correct_estimates
      resources :invite_officials
      post 'estimates_quick_save' => 'quick_saves#estimates', :as => :estimates_quick_save
      post 'shots_quick_save' => 'quick_saves#shots', :as => :shots_quick_save
      post 'time_quick_save' => 'quick_saves#time', :as => :time_quick_save
      resources :quick_saves
      resources :media
      resource :finish_race
      resource :uploads
      get 'upload/success' => 'uploads#success'
      get 'upload/error' => 'uploads#error'
    end

    resources :series do
      resources :competitors, :except => :create
      resources :age_groups
      resource :start_list
      resources :shots
      resources :estimates
      resources :times
    end
    
    root :to => "index#show"
  end

  resources :remote_races

  root :to => "home#show"
end
