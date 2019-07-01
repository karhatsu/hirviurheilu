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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_01_051746) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activation_keys", id: :serial, force: :cascade do |t|
    t.string "comment", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "age_groups", id: :serial, force: :cascade do |t|
    t.integer "series_id", null: false
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "min_competitors", default: 0, null: false
    t.boolean "shorter_trip", default: false, null: false
  end

  create_table "announcements", id: :serial, force: :cascade do |t|
    t.date "published", null: false
    t.string "title", limit: 255, null: false
    t.text "content", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "front_page"
  end

  create_table "base_prices", id: :serial, force: :cascade do |t|
    t.integer "price", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "race_id", null: false
    t.string "long_name", limit: 255
    t.index ["race_id"], name: "index_clubs_on_race_id"
  end

  create_table "competitors", id: :serial, force: :cascade do |t|
    t.integer "series_id", null: false
    t.integer "club_id", null: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.integer "number"
    t.time "start_time"
    t.time "arrival_time"
    t.integer "shots_total_input"
    t.integer "estimate1"
    t.integer "estimate2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "no_result_reason", limit: 255
    t.integer "age_group_id"
    t.integer "correct_estimate1"
    t.integer "correct_estimate2"
    t.integer "estimate3"
    t.integer "estimate4"
    t.integer "correct_estimate3"
    t.integer "correct_estimate4"
    t.boolean "unofficial", default: false, null: false
    t.string "team_name", limit: 255
    t.boolean "has_result", default: false, null: false
    t.integer "shooting_overtime_min"
    t.time "shooting_start_time"
    t.time "shooting_finish_time"
    t.integer "shot_0"
    t.integer "shot_1"
    t.integer "shot_2"
    t.integer "shot_3"
    t.integer "shot_4"
    t.integer "shot_5"
    t.integer "shot_6"
    t.integer "shot_7"
    t.integer "shot_8"
    t.integer "shot_9"
    t.index ["age_group_id"], name: "index_competitors_on_age_group_id"
    t.index ["series_id"], name: "index_competitors_on_series_id"
  end

  create_table "correct_estimates", id: :serial, force: :cascade do |t|
    t.integer "race_id", null: false
    t.integer "min_number", null: false
    t.integer "max_number"
    t.integer "distance1", null: false
    t.integer "distance2", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "distance3"
    t.integer "distance4"
  end

  create_table "cup_officials", id: false, force: :cascade do |t|
    t.integer "cup_id", null: false
    t.integer "user_id", null: false
  end

  create_table "cup_series", id: :serial, force: :cascade do |t|
    t.integer "cup_id"
    t.string "name", limit: 255, null: false
    t.string "series_names", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "top_competitions", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "include_always_last_race", default: false, null: false
  end

  create_table "cups_races", id: :serial, force: :cascade do |t|
    t.integer "cup_id", null: false
    t.integer "race_id", null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", id: :serial, force: :cascade do |t|
    t.integer "min_competitors", default: 0, null: false
    t.decimal "price", default: "0.0", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_rights", id: :serial, force: :cascade do |t|
    t.integer "race_id", null: false
    t.integer "user_id", null: false
    t.boolean "only_add_competitors", default: false, null: false
    t.integer "club_id"
    t.boolean "primary", default: false, null: false
    t.boolean "new_clubs", default: false, null: false
  end

  create_table "races", id: :serial, force: :cascade do |t|
    t.integer "sport_id", null: false
    t.string "name", limit: 255, null: false
    t.string "location", limit: 255, null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "start_interval_seconds"
    t.boolean "finished", default: false, null: false
    t.integer "series_count", default: 0, null: false
    t.string "home_page", limit: 255
    t.integer "batch_size", default: 0, null: false
    t.integer "batch_interval_seconds", default: 180, null: false
    t.integer "club_level", default: 0, null: false
    t.integer "start_order", default: 1, null: false
    t.text "video_source"
    t.text "video_description"
    t.string "organizer", limit: 255
    t.time "start_time", default: "2000-01-01 00:00:00", null: false
    t.string "organizer_phone", limit: 255
    t.string "billing_info"
    t.text "public_message"
    t.string "api_secret"
    t.string "address"
    t.integer "district_id"
    t.index ["sport_id"], name: "index_races_on_sport_id"
  end

  create_table "relay_competitors", id: :serial, force: :cascade do |t|
    t.integer "relay_team_id", null: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.integer "leg", null: false
    t.time "start_time"
    t.time "arrival_time"
    t.integer "misses"
    t.integer "estimate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "adjustment"
    t.index ["relay_team_id"], name: "index_relay_competitors_on_relay_team_id"
  end

  create_table "relay_correct_estimates", id: :serial, force: :cascade do |t|
    t.integer "relay_id", null: false
    t.integer "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "leg", null: false
    t.index ["relay_id"], name: "index_relay_correct_estimates_on_relay_id"
  end

  create_table "relay_teams", id: :serial, force: :cascade do |t|
    t.integer "relay_id", null: false
    t.string "name", limit: 255, null: false
    t.integer "number", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "no_result_reason", limit: 255
    t.index ["relay_id"], name: "index_relay_teams_on_relay_id"
  end

  create_table "relays", id: :serial, force: :cascade do |t|
    t.integer "race_id", null: false
    t.integer "start_day", null: false
    t.time "start_time"
    t.string "name", limit: 255, null: false
    t.integer "legs_count", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "finished", default: false, null: false
    t.integer "leg_distance"
    t.integer "estimate_penalty_distance"
    t.integer "shooting_penalty_distance"
    t.index ["race_id"], name: "index_relays_on_race_id"
  end

  create_table "rights", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["user_id"], name: "index_rights_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", id: :serial, force: :cascade do |t|
    t.integer "race_id", null: false
    t.string "name", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time "start_time"
    t.integer "first_number"
    t.boolean "has_start_list", default: false, null: false
    t.integer "competitors_count", default: 0, null: false
    t.integer "start_day", default: 1, null: false
    t.integer "estimates", default: 2, null: false
    t.integer "national_record"
    t.integer "time_points_type", default: 0, null: false
    t.integer "points_method", default: 0, null: false
    t.boolean "shorter_trip", default: false, null: false
    t.index ["race_id"], name: "index_series_on_race_id"
  end

  create_table "shots", id: :serial, force: :cascade do |t|
    t.integer "competitor_id", null: false
    t.integer "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["competitor_id"], name: "index_shots_on_competitor_id"
  end

  create_table "sports", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "key", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_competition_age_groups", id: false, force: :cascade do |t|
    t.integer "team_competition_id", null: false
    t.integer "age_group_id", null: false
    t.index ["team_competition_id"], name: "index_team_competition_age_groups_on_team_competition_id"
  end

  create_table "team_competition_series", id: false, force: :cascade do |t|
    t.integer "team_competition_id", null: false
    t.integer "series_id", null: false
    t.index ["team_competition_id"], name: "index_team_competition_series_on_team_competition_id"
  end

  create_table "team_competitions", id: :serial, force: :cascade do |t|
    t.integer "race_id", null: false
    t.string "name", limit: 255, null: false
    t.integer "team_competitor_count", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "use_team_name", default: false, null: false
    t.boolean "multiple_teams", default: false, null: false
    t.index ["race_id"], name: "index_team_competitions_on_race_id"
  end

  create_table "user_sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_user_sessions_on_session_id"
    t.index ["updated_at"], name: "index_user_sessions_on_updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.string "crypted_password", limit: 255, null: false
    t.string "password_salt", limit: 255, null: false
    t.string "persistence_token", limit: 255, null: false
    t.string "single_access_token", limit: 255, null: false
    t.string "perishable_token", limit: 255, null: false
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip", limit: 255
    t.string "last_login_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "reset_hash", limit: 255
    t.string "activation_key", limit: 255
    t.text "invoicing_info"
    t.string "club_name"
    t.index ["email"], name: "index_users_on_email"
  end

end
