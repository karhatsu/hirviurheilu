ElkSports::Application.routes.draw do
  scope "(/:locale)", :locale => /#{I18n.available_locales.join('|')}/ do
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
  
    resources :announcements
    resource :info
    get 'answers' => 'infos#answers', :as => :answers
    resources :feedbacks
  
    get 'offline', to: redirect('/')
    get 'offline_vs_online', to: redirect('/')
    get 'offline_installation', to: redirect('/')
    get 'offline_price', to: redirect('/')
    get 'offline_version_history', to: redirect('/')
    get 'download/installer', to: redirect('/')
    
    resources :prices
    resources :offers, only: [:new, :create]
    get 'offer_sent' => 'offers#sent', as: :offer_sent
    
    resources :cups do
      resources :cup_series
    end
  
    resources :races do
      resources :series do
        resource :start_list, only: :show
      end
      resources :start_lists, only: :index
      resources :team_competitions
      resources :relays
      resource :result_rotation
      resource :medium
      resource :video
    end
  
    resources :series do
      resources :competitors
      resource :start_list
    end
  
    resources :relays do
      resources :legs
    end
  
    namespace :admin do
      resources :announcements
      resources :races
      resources :users
      root :to => "index#show"
    end
  
    namespace :official do
      namespace :limited do
        resources :races do
          resources :competitors
          resources :csv_imports
        end
      end
      
      resources :cups
      
      resources :races do
        resources :competitors, :only => [:create, :update]
        get 'clubs/competitors' => 'clubs#competitors'
        resources :clubs
        put 'correct_estimates' => 'correct_estimates#update', :as => :correct_estimates
        resources :correct_estimates
        resources :race_rights
        get 'estimates_quick_save' => 'quick_saves#estimates', :as => :estimates_quick_save
        get 'shots_quick_save' => 'quick_saves#shots', :as => :shots_quick_save
        get 'times_quick_save' => 'quick_saves#times', :as => :times_quick_save
        post 'estimates_quick_save' => 'quick_saves#save_estimates', :as => :quick_save_estimates
        post 'shots_quick_save' => 'quick_saves#save_shots', :as => :quick_save_shots
        post 'time_quick_save' => 'quick_saves#save_time', :as => :quick_save_time
        post 'no_result_quick_save' => 'quick_saves#save_no_result', :as => :quick_save_no_result
        resources :quick_saves
        resource :finish_race
        resource :exports
        get 'export/success' => 'exports#success'
        get 'export/error' => 'exports#error'
        resources :relays
        resources :team_competitions
        resources :csv_imports
        resource :start_list
        resource :csv_export
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
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :races, only: [] do
        resources :competitors, only: [] do
          resource :start_time, only: :update
          resource :shooting_start_time, only: :update
          resource :shooting_finish_time, only: :update
          resource :arrival_time, only: :update
        end
      end
    end
  end

  get '/:locale' => 'home#show', :locale => /#{I18n.available_locales.join('|')}/
  root :to => "home#show"
end
