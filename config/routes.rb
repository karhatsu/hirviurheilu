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

  resource :info
  resources :feedbacks
  
  post 'calculate_price' => 'prices#calculate_price', :as => :calculate_price
  resources :prices

  resources :races

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
      resources :clubs
      put 'correct_estimates' => 'correct_estimates#update', :as => :correct_estimates
      resources :correct_estimates
      resources :officials
      resource :finish_race
    end

    resources :series do
      resources :competitors
      resource :start_list
      resources :shots
      resources :estimates
      resources :times
    end
    
    root :to => "index#show"
  end

  root :to => "home#show"
end
