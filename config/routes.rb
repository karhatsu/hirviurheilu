ElkSports::Application.routes.draw do
  resource :home

  resource :user_session
  resource :account, :controller => 'users'
  resources :users

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  match 'races/:race_id/series/:id/start_list' => 'series#start_list', :as => :start_list
  resources :races do
    resources :series
  end

  resources :series do
    resources :competitors
  end
  resources :competitors

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  namespace :admin do
    resources :clubs do as_routes end
    resources :sports do as_routes end
    root :to => "index#show"
  end

  namespace :official do
    resources :races
    resources :series do
      resources :competitors
    end
    root :to => "index#show"
  end

  root :to => "home#show"
end
