ElkSports::Application.routes.draw do
  resource :home

  match 'logout' => 'user_sessions#destroy', :method => :post, :as => :logout
  resource :user_session
  resource :account, :controller => 'users'
  resources :users

  match 'series/:series_id/start_list' => 'start_lists#show', :as => :start_list
  resources :races

  resources :series do
    resources :competitors
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
      resource :finish_race
    end
    match '/series/:id/generate_numbers' => 'series#generate_numbers',
      :as => :generate_numbers
    match '/series/:id/generate_times' => 'series#generate_times',
      :as => :generate_times
    match '/shots/change_series' => 'shots#change_series'
    resources :series do
      resources :competitors
      resources :shots
    end
    root :to => "index#show"
  end

  root :to => "home#show"
end
