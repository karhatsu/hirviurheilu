# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110310163521) do

  create_table "activation_keys", :force => true do |t|
    t.string   "comment",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "age_groups", :force => true do |t|
    t.integer  "series_id",                      :null => false
    t.string   "name",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_competitors", :default => 0, :null => false
  end

  create_table "base_prices", :force => true do |t|
    t.integer  "price",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "race_id",    :null => false
  end

  add_index "clubs", ["race_id"], :name => "index_clubs_on_race_id"

  create_table "competitors", :force => true do |t|
    t.integer  "series_id",         :null => false
    t.integer  "club_id",           :null => false
    t.string   "first_name",        :null => false
    t.string   "last_name",         :null => false
    t.integer  "number"
    t.time     "start_time"
    t.time     "arrival_time"
    t.integer  "shots_total_input"
    t.integer  "estimate1"
    t.integer  "estimate2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "no_result_reason"
    t.integer  "age_group_id"
    t.integer  "correct_estimate1"
    t.integer  "correct_estimate2"
    t.integer  "estimate3"
    t.integer  "estimate4"
    t.integer  "correct_estimate3"
    t.integer  "correct_estimate4"
  end

  add_index "competitors", ["series_id"], :name => "index_competitors_on_series_id"

  create_table "correct_estimates", :force => true do |t|
    t.integer  "race_id",    :null => false
    t.integer  "min_number", :null => false
    t.integer  "max_number"
    t.integer  "distance1",  :null => false
    t.integer  "distance2",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "distance3"
    t.integer  "distance4"
  end

  create_table "default_age_groups", :force => true do |t|
    t.integer  "default_series_id",                :null => false
    t.string   "name",                             :null => false
    t.integer  "min_competitors",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_series", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "min_competitors", :default => 0,   :null => false
    t.decimal  "price",           :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_officials", :id => false, :force => true do |t|
    t.integer "race_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "races", :force => true do |t|
    t.integer  "sport_id",                                  :null => false
    t.string   "name",                                      :null => false
    t.string   "location",                                  :null => false
    t.date     "start_date",                                :null => false
    t.date     "end_date",                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_interval_seconds"
    t.boolean  "finished",               :default => false, :null => false
    t.integer  "series_count",           :default => 0,     :null => false
    t.integer  "team_competitor_count"
    t.string   "home_page"
  end

  add_index "races", ["sport_id"], :name => "index_races_on_sport_id"

  create_table "relay_competitors", :force => true do |t|
    t.integer  "relay_team_id", :null => false
    t.string   "first_name",    :null => false
    t.string   "last_name",     :null => false
    t.integer  "leg",           :null => false
    t.time     "start_time"
    t.time     "arrival_time"
    t.integer  "misses"
    t.integer  "estimate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relay_competitors", ["relay_team_id"], :name => "index_relay_competitors_on_relay_team_id"

  create_table "relay_teams", :force => true do |t|
    t.integer  "relay_id",   :null => false
    t.string   "name",       :null => false
    t.integer  "number",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relay_teams", ["relay_id"], :name => "index_relay_teams_on_relay_id"

  create_table "relays", :force => true do |t|
    t.integer  "race_id",    :null => false
    t.integer  "start_day",  :null => false
    t.time     "start_time"
    t.string   "name",       :null => false
    t.integer  "legs_count", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relays", ["race_id"], :name => "index_relays_on_race_id"

  create_table "rights", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "role_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rights", ["user_id"], :name => "index_rights_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.integer  "race_id",                              :null => false
    t.string   "name",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "start_time"
    t.integer  "first_number"
    t.boolean  "has_start_list",    :default => false, :null => false
    t.integer  "competitors_count", :default => 0,     :null => false
    t.integer  "start_day",         :default => 1,     :null => false
    t.boolean  "no_time_points",    :default => false, :null => false
    t.integer  "estimates",         :default => 2,     :null => false
  end

  add_index "series", ["race_id"], :name => "index_series_on_race_id"

  create_table "shots", :force => true do |t|
    t.integer  "competitor_id", :null => false
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shots", ["competitor_id"], :name => "index_shots_on_competitor_id"

  create_table "sports", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "key",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["updated_at"], :name => "index_user_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "first_name",                         :null => false
    t.string   "last_name",                          :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_hash"
    t.string   "activation_key"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
