Hirviurheilu::Application.routes.draw do
  scope "(/:locale)", :locale => /#{I18n.available_locales.join('|')}/ do
    resource :home

    delete 'logout' => 'user_sessions#destroy', :as => :logout
    get 'login' => 'user_sessions#new', :as => :login
    resource :user_session

    resource :account, :controller => 'users'
    get 'register' => 'users#new', :as => :register
    resources :users
    resource :passwords, only: [:edit, :update]
    get 'reset_password/:reset_hash/edit' => 'reset_passwords#edit', :as => :edit_reset_password
    resource :reset_password

    resources :announcements
    resource :info
    get 'answers' => 'infos#answers', :as => :answers
    get 'sports_info' => 'infos#sports_info'
    resources :feedbacks, only: :new

    resources :prices
    get 'offers/new', to: redirect('/prices')

    resources :cups do
      resources :cup_series
      resources :cup_team_competitions, only: :show
      resources :rifle_cup_series
      resource :medium, only: [:show, :new]
      resource :press, only: :show
    end

    resources :races do
      get 'rifle', to: 'european_rifles#index'
      get 'shotguns', to: 'european_shotguns#index'
      get 'trap', to: 'nordic_races#trap', as: :trap
      get 'shotgun', to: 'nordic_races#shotgun', as: :shotgun
      get 'rifle_moving', to: 'nordic_races#rifle_moving', as: :rifle_moving
      get 'rifle_standing', to: 'nordic_races#rifle_standing', as: :rifle_standing
      resources :qualification_round_heats, only: :index
      resources :final_round_heats, only: :index
      resources :series do
        get 'rifle', to: 'european_rifles#index', as: :rifle
        get 'shotguns', to: 'european_shotguns#index'
        get 'trap', to: 'nordic_races#trap'
        get 'shotgun', to: 'nordic_races#shotgun'
        get 'rifle_moving', to: 'nordic_races#rifle_moving'
        get 'rifle_standing', to: 'nordic_races#rifle_standing'
        resource :start_list, only: :show
      end
      resources :start_lists, only: :index
      resources :team_competitions
      resources :rifle_team_competitions, only: :show
      resources :relays do
        get 'start_list' => 'relays#start_list'
        resources :legs, only: :show
      end
      resource :result_rotation, only: :show
      resource :medium, only: [:show, :new]
      resource :press, only: :show
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
      resources :stats, only: :index
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

      resources :multiple_races, only: [:new, :create]

      resources :events, only: [:show, :new, :create, :edit, :update] do
        resource :competitor_numbers_sync, only: [:show, :update]
      end

      resources :races do
        resources :heats
        resource :heat_list_reset, only: [:show, :destroy]
        resources :qualification_round_heat_lists, only: :index
        resources :final_round_heat_lists, only: :index
        post 'qualification_round_heat_results/:number' => 'qualification_round_heat_results#create'
        post 'final_round_heat_results/:number' => 'final_round_heat_results#create'
        resources :competitor_numbers, only: :index
        get 'nordic_heat_lists_trap', to: 'nordic_heat_lists#trap'
        get 'nordic_heat_lists_shotgun', to: 'nordic_heat_lists#shotgun'
        get 'nordic_heat_lists_rifle_moving', to: 'nordic_heat_lists#rifle_moving'
        get 'nordic_heat_lists_rifle_standing', to: 'nordic_heat_lists#rifle_standing'
        get 'european_heat_lists_trap', to: 'european_heat_lists#trap'
        get 'european_heat_lists_compak', to: 'european_heat_lists#compak'
        get 'european_heat_lists_rifle', to: 'european_heat_lists#rifle'
        resource :heat_list_template, only: :show
        get 'competitor_numbers/:number' => 'competitors#show_by_number'
        put 'competitors/:competitor_id/track_place' => 'competitor_track_places#update'
        delete 'competitors/:competitor_id/track_place' => 'competitor_track_places#destroy'
        resources :competitors, :only => [:create, :update]
        get 'competitors' => 'races#competitors'
        get 'clubs/competitors' => 'clubs#competitors'
        resources :clubs
        put 'correct_estimates' => 'correct_estimates#update', :as => :correct_estimates
        resources :correct_estimates
        post 'race_rights/multiple' => 'race_rights#multiple'
        resources :race_rights
        post 'estimates_quick_save' => 'quick_saves#save_estimates', :as => :quick_save_estimates
        post 'shots_quick_save' => 'quick_saves#save_shots', :as => :quick_save_shots
        post 'time_quick_save' => 'quick_saves#save_time', :as => :quick_save_time
        post 'qualification_round_shots_quick_save' => 'quick_saves#save_qualification_round_shots', as: :quick_save_qualification_round_shots
        post 'final_round_shots_quick_save' => 'quick_saves#save_final_round_shots', as: :quick_save_final_round_shots
        post 'extra_shots_quick_save' => 'quick_saves#save_extra_shots', as: :quick_save_extra_shots
        post 'no_result_quick_save' => 'quick_saves#save_no_result', :as => :quick_save_no_result
        patch 'national_records' => 'national_records#update_all', as: :update_national_records
        resources :national_records, only: :index
        resources :megalink_imports, only: :index
        resources :quick_saves
        resource :finish_race
        get 'export/success' => 'exports#success'
        get 'export/error' => 'exports#error'
        resources :relays
        resources :team_competitions
        resources :csv_imports
        resource :start_list
        resource :csv_export
        resource :competitor_copying
        resources :shooting_by_heats, only: :index
        get 'nordic_trap', to: 'nordic_race_shots#trap', as: :nordic_trap
        get 'nordic_shotgun', to: 'nordic_race_shots#shotgun', as: :nordic_shotgun
        get 'nordic_rifle_moving', to: 'nordic_race_shots#rifle_moving', as: :nordic_rifle_moving
        get 'nordic_rifle_standing', to: 'nordic_race_shots#rifle_standing', as: :nordic_rifle_standing
        get 'european_trap', to: 'european_race_shots#trap', as: :european_trap
        get 'european_compak', to: 'european_race_shots#compak', as: :european_compak
        get 'european_rifle', to: 'european_race_shots#rifle', as: :european_rifle
        resource :printing, only: :show
      end

      resources :series do
        resource :qualification_round_heat_list, only: [:show, :create]
        resource :final_round_heat_list, only: [:show, :create]
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
        post 'relay_estimate_penalties_adjustment_quick_save' => 'relay_quick_saves#estimate_penalties_adjustment',
             :as => :relay_estimate_penalties_adjustment_quick_save
        post 'relay_shooting_penalties_adjustment_quick_save' => 'relay_quick_saves#shooting_penalties_adjustment',
             :as => :relay_shooting_penalties_adjustment_quick_save
        resources :relay_quick_saves
        resource :finish_relay
      end

      root :to => "index#show"
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v2 do
      namespace :official do
        resources :races, only: [:show] do
          resource :health, only: :show
          resources :relays, only: [] do
            put '/relay_teams/:team_number/legs/:leg/arrival_time' => 'relay_arrival_times#update'
          end
          put '/competitors/:competitor_number/start_time' => 'start_times#update'
          put '/competitors/:competitor_number/shooting_start_time' => 'shooting_start_times#update'
          put '/competitors/:competitor_number/shooting_finish_time' => 'shooting_finish_times#update'
          put '/competitors/:competitor_number/arrival_time' => 'arrival_times#update'
          put '/competitors/:competitor_number/shots' => 'shots#update_all'
          put '/competitors/:competitor_number/extra_shots' => 'extra_shots#update_all'
          put '/competitors/:competitor_number/shots/:shot_number' => 'shots#update'
          put '/competitors/:competitor_number/extra_shots/:shot_number' => 'extra_shots#update'
        end
      end

      namespace :public do
        get 'home', to: 'home#index'
        resources :announcements, only: [:index, :show]
        resources :districts, only: :index
        resources :races, only: [:index, :show] do
          resources :series, only: [:show] do
            resource :start_list, only: :show
            get 'rifle', to: 'european_rifles#show'
            get 'shotguns', to: 'european_shotguns#show'
            get 'trap', to: 'nordic_races#trap'
            get 'shotgun', to: 'nordic_races#shotgun'
            get 'rifle_moving', to: 'nordic_races#rifle_moving'
            get 'rifle_standing', to: 'nordic_races#rifle_standing'
          end
          resources :rifle_team_competitions, only: [:show]
          resources :team_competitions, only: [:show]
          resources :relays, only: [:show]
          resources :times, only: :index
          resource :press, only: :show
          resources :qualification_round_heats, only: :index
          resources :final_round_heats, only: :index
          get 'rifle', to: 'european_rifles#show'
          get 'shotguns', to: 'european_shotguns#show'
          get 'trap', to: 'nordic_races#trap'
          get 'shotgun', to: 'nordic_races#shotgun'
          get 'rifle_moving', to: 'nordic_races#rifle_moving'
          get 'rifle_standing', to: 'nordic_races#rifle_standing'
          get '/competitors/:competitor_number', to: 'competitors#show'
        end
        resources :recent_races, only: :index
        resources :cups, only: :show do
          resources :cup_series, only: :show
          resources :rifle_cup_series, only: :show
          resources :cup_team_competitions, only: :show
        end
        resources :feedbacks, only: :create
      end
    end
  end

  get '/:locale' => 'home#show', :locale => /#{I18n.available_locales.join('|')}/
  root :to => "home#show"
end
