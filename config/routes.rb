ElkSports::Application.routes.draw do
  resource :home

  resources :sports do as_routes end
  resources :clubs do as_routes end

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

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => "home#show"
end
