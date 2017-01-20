# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170120155426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activation_keys", force: :cascade do |t|
    t.string   "comment",    limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "age_groups", force: :cascade do |t|
    t.integer  "series_id",                                   null: false
    t.string   "name",            limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_competitors",             default: 0,     null: false
    t.boolean  "shorter_trip",                default: false, null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.date     "published",                              null: false
    t.string   "title",      limit: 255,                 null: false
    t.text     "content",                                null: false
    t.boolean  "active",                 default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "front_page"
  end

  create_table "base_prices", force: :cascade do |t|
    t.integer  "price",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "race_id",                null: false
    t.string   "long_name",  limit: 255
  end

  add_index "clubs", ["race_id"], name: "index_clubs_on_race_id", using: :btree

  create_table "competitors", force: :cascade do |t|
    t.integer  "series_id",                                         null: false
    t.integer  "club_id",                                           null: false
    t.string   "first_name",            limit: 255,                 null: false
    t.string   "last_name",             limit: 255,                 null: false
    t.integer  "number"
    t.time     "start_time"
    t.time     "arrival_time"
    t.integer  "shots_total_input"
    t.integer  "estimate1"
    t.integer  "estimate2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "no_result_reason",      limit: 255
    t.integer  "age_group_id"
    t.integer  "correct_estimate1"
    t.integer  "correct_estimate2"
    t.integer  "estimate3"
    t.integer  "estimate4"
    t.integer  "correct_estimate3"
    t.integer  "correct_estimate4"
    t.boolean  "unofficial",                        default: false, null: false
    t.string   "team_name",             limit: 255
    t.boolean  "has_result",                        default: false, null: false
    t.integer  "shooting_overtime_min"
    t.time     "shooting_start_time"
    t.time     "shooting_finish_time"
  end

  add_index "competitors", ["age_group_id"], name: "index_competitors_on_age_group_id", using: :btree
  add_index "competitors", ["series_id"], name: "index_competitors_on_series_id", using: :btree

  create_table "correct_estimates", force: :cascade do |t|
    t.integer  "race_id",    null: false
    t.integer  "min_number", null: false
    t.integer  "max_number"
    t.integer  "distance1",  null: false
    t.integer  "distance2",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "distance3"
    t.integer  "distance4"
  end

  create_table "cup_officials", id: false, force: :cascade do |t|
    t.integer "cup_id",  null: false
    t.integer "user_id", null: false
  end

  create_table "cup_series", force: :cascade do |t|
    t.integer  "cup_id"
    t.string   "name",         limit: 255, null: false
    t.string   "series_names", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "cups", force: :cascade do |t|
    t.string   "name",             limit: 255,             null: false
    t.integer  "top_competitions",             default: 2, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "cups_races", force: :cascade do |t|
    t.integer "cup_id",  null: false
    t.integer "race_id", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "min_competitors", default: 0,   null: false
    t.decimal  "price",           default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_rights", force: :cascade do |t|
    t.integer "race_id",                              null: false
    t.integer "user_id",                              null: false
    t.boolean "only_add_competitors", default: false, null: false
    t.integer "club_id"
    t.boolean "primary",              default: false, null: false
    t.boolean "new_clubs",            default: false, null: false
  end

  create_table "races", force: :cascade do |t|
    t.integer  "sport_id",                                                           null: false
    t.string   "name",                   limit: 255,                                 null: false
    t.string   "location",               limit: 255,                                 null: false
    t.date     "start_date",                                                         null: false
    t.date     "end_date",                                                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_interval_seconds"
    t.boolean  "finished",                           default: false,                 null: false
    t.integer  "series_count",                       default: 0,                     null: false
    t.string   "home_page",              limit: 255
    t.integer  "batch_size",                         default: 0,                     null: false
    t.integer  "batch_interval_seconds",             default: 180,                   null: false
    t.integer  "club_level",                         default: 0,                     null: false
    t.integer  "start_order",                        default: 1,                     null: false
    t.text     "video_source"
    t.text     "video_description"
    t.string   "organizer",              limit: 255
    t.time     "start_time",                         default: '2000-01-01 00:00:00', null: false
    t.string   "organizer_phone",        limit: 255
    t.string   "billing_info"
    t.text     "public_message"
  end

  add_index "races", ["sport_id"], name: "index_races_on_sport_id", using: :btree

  create_table "relay_competitors", force: :cascade do |t|
    t.integer  "relay_team_id",             null: false
    t.string   "first_name",    limit: 255, null: false
    t.string   "last_name",     limit: 255, null: false
    t.integer  "leg",                       null: false
    t.time     "start_time"
    t.time     "arrival_time"
    t.integer  "misses"
    t.integer  "estimate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adjustment"
  end

  add_index "relay_competitors", ["relay_team_id"], name: "index_relay_competitors_on_relay_team_id", using: :btree

  create_table "relay_correct_estimates", force: :cascade do |t|
    t.integer  "relay_id",   null: false
    t.integer  "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "leg",        null: false
  end

  add_index "relay_correct_estimates", ["relay_id"], name: "index_relay_correct_estimates_on_relay_id", using: :btree

  create_table "relay_teams", force: :cascade do |t|
    t.integer  "relay_id",                     null: false
    t.string   "name",             limit: 255, null: false
    t.integer  "number",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "no_result_reason", limit: 255
  end

  add_index "relay_teams", ["relay_id"], name: "index_relay_teams_on_relay_id", using: :btree

  create_table "relays", force: :cascade do |t|
    t.integer  "race_id",                                null: false
    t.integer  "start_day",                              null: false
    t.time     "start_time"
    t.string   "name",       limit: 255,                 null: false
    t.integer  "legs_count",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finished",               default: false, null: false
  end

  add_index "relays", ["race_id"], name: "index_relays_on_race_id", using: :btree

  create_table "rights", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  add_index "rights", ["user_id"], name: "index_rights_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", force: :cascade do |t|
    t.integer  "race_id",                                       null: false
    t.string   "name",              limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "start_time"
    t.integer  "first_number"
    t.boolean  "has_start_list",                default: false, null: false
    t.integer  "competitors_count",             default: 0,     null: false
    t.integer  "start_day",                     default: 1,     null: false
    t.integer  "estimates",                     default: 2,     null: false
    t.integer  "national_record"
    t.integer  "time_points_type",              default: 0,     null: false
  end

  add_index "series", ["race_id"], name: "index_series_on_race_id", using: :btree

  create_table "shots", force: :cascade do |t|
    t.integer  "competitor_id", null: false
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shots", ["competitor_id"], name: "index_shots_on_competitor_id", using: :btree

  create_table "sports", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "key",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_competition_age_groups", id: false, force: :cascade do |t|
    t.integer "team_competition_id", null: false
    t.integer "age_group_id",        null: false
  end

  add_index "team_competition_age_groups", ["team_competition_id"], name: "index_team_competition_age_groups_on_team_competition_id", using: :btree

  create_table "team_competition_series", id: false, force: :cascade do |t|
    t.integer "team_competition_id", null: false
    t.integer "series_id",           null: false
  end

  add_index "team_competition_series", ["team_competition_id"], name: "index_team_competition_series_on_team_competition_id", using: :btree

  create_table "team_competitions", force: :cascade do |t|
    t.integer  "race_id",                                           null: false
    t.string   "name",                  limit: 255,                 null: false
    t.integer  "team_competitor_count",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_team_name",                     default: false, null: false
    t.boolean  "multiple_teams",                    default: false, null: false
  end

  add_index "team_competitions", ["race_id"], name: "index_team_competitions_on_race_id", using: :btree

  create_table "user_sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["session_id"], name: "index_user_sessions_on_session_id", using: :btree
  add_index "user_sessions", ["updated_at"], name: "index_user_sessions_on_updated_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",          limit: 255,             null: false
    t.string   "last_name",           limit: 255,             null: false
    t.string   "email",               limit: 255,             null: false
    t.string   "crypted_password",    limit: 255,             null: false
    t.string   "password_salt",       limit: 255,             null: false
    t.string   "persistence_token",   limit: 255,             null: false
    t.string   "single_access_token", limit: 255,             null: false
    t.string   "perishable_token",    limit: 255,             null: false
    t.integer  "login_count",                     default: 0, null: false
    t.integer  "failed_login_count",              default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 255
    t.string   "last_login_ip",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_hash",          limit: 255
    t.string   "activation_key",      limit: 255
    t.text     "invoicing_info"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
