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

  match 'change_series' => 'series#change_series', :as => :change_series
  match 'change_start_list' => 'start_lists#change_start_list', :as => :change_start_list

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
    resources :default_series do as_routes end
    resources :default_age_groups do as_routes end
    root :to => "index#show"
  end

  namespace :official do
    resources :races do
      resources :clubs
      resources :officials
      resource :finish_race
    end
    match '/series/:id/generate_numbers' => 'series#generate_numbers',
      :as => :generate_numbers
    match '/series/:id/generate_times' => 'series#generate_times',
      :as => :generate_times
    match '/shots/change_series' => 'shots#change_series'
    match '/series/:series_id/estimates' => 'estimates#index', :as => :series_estimates
    match '/estimates/change_series' => 'estimates#change_series'
    match '/series/:series_id/times' => 'times#index', :as => :series_times
    match '/change_series' => 'series#change_series', :as => :change_series
    match '/times/change_series' => 'times#change_series'
    resources :series do
      resources :competitors
      resource :start_list
      resources :shots
    end
    root :to => "index#show"
  end

  root :to => "home#show"
end
