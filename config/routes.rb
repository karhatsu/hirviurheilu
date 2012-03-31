ElkSports::Application.routes.draw do
  resource :home

  delete 'logout' => 'user_sessions#destroy', :as => :logout
  get 'login' => 'user_sessions#new', :as => :login
  resource :user_session

  resource :account, :controller => 'users'
  get 'register' => 'users#new', :as => :register
  resources :users
  get 'reset_password/:reset_hash/edit' => 'reset_passwords#edit', :as => :edit_reset_password
  resource :reset_password
  resource :license
  resource :activation_key

  resource :mode

  resource :info
  resources :feedbacks

  get 'offline', :to => redirect('/offline_vs_online')
  get 'offline_vs_online' => 'offline_infos#comparison', :as => :offline_vs_online
  get 'offline_installation' => 'offline_infos#installation', :as => :offline_installation
  get 'offline_price' => 'offline_infos#price', :as => :offline_price
  get 'offline_version_history' => 'offline_infos#version_history', :as => :offline_version_history
  get 'download/installer' => 'downloads#installer', :as => :download_installer
  
  post 'calculate_price' => 'prices#calculate_price', :as => :calculate_price
  resources :prices
  
  resources :cups do
    resources :cup_series
  end

  resources :races do
    resources :start_lists
    resources :team_competitions
    resources :relays
    resource :result_rotation
    resource :medium
  end

  resources :series do
    resources :competitors
    resource :start_list
  end

  resources :relays do
    resources :legs
  end

  namespace :admin do
    resources :users
    root :to => "index#show"
  end

  namespace :official do
    resources :races do
      resources :competitors, :only => [:create, :update]
      resources :clubs
      put 'correct_estimates' => 'correct_estimates#update', :as => :correct_estimates
      resources :correct_estimates
      resources :invite_officials
      post 'estimates_quick_save' => 'quick_saves#estimates', :as => :estimates_quick_save
      post 'shots_quick_save' => 'quick_saves#shots', :as => :shots_quick_save
      post 'time_quick_save' => 'quick_saves#time', :as => :time_quick_save
      post 'no_result_quick_save' => 'quick_saves#no_result', :as => :no_result_quick_save
      resources :quick_saves
      resource :finish_race
      resource :exports
      get 'export/success' => 'exports#success'
      get 'export/error' => 'exports#error'
      resources :relays
      resources :team_competitions
      resources :csv_imports
      resource :start_list
    end

    resources :series do
      resources :competitors, :except => :create
      resources :age_groups
      resource :start_list
      resources :shots
      resources :estimates
      resources :times
    end

    resources :relays do
      resources :relay_teams
      post 'relay_estimate_quick_save' => 'relay_quick_saves#estimate',
        :as => :relay_estimate_quick_save
      post 'relay_misses_quick_save' => 'relay_quick_saves#misses',
        :as => :relay_misses_quick_save
      post 'relay_time_quick_save' => 'relay_quick_saves#time',
        :as => :relay_time_quick_save
      post 'relay_adjustment_quick_save' => 'relay_quick_saves#adjustment',
        :as => :relay_adjustment_quick_save
      resources :relay_quick_saves
      resource :finish_relay
    end
    
    root :to => "index#show"
  end

  resources :remote_races


  root :to => "home#show"
end
