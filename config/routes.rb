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
    resources :clubs do as_routes end
    resources :sports do as_routes end
    root :to => "index#show"
  end

  namespace :official do
    resources :races do
      resource :finish_race
    end
    match '/series/:series_id/competitors/generate_numbers' => 'competitors#generate_numbers',
      :as => :generate_numbers
    match '/series/:series_id/competitors/generate_times' => 'competitors#generate_times',
      :as => :generate_times
    resources :series do
      resources :competitors
    end
    root :to => "index#show"
  end

  root :to => "home#show"
end
