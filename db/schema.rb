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

ActiveRecord::Schema.define(:version => 20100815053744) do

  create_table "clubs", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitors", :force => true do |t|
    t.integer  "series_id",         :null => false
    t.integer  "club_id",           :null => false
    t.string   "first_name",        :null => false
    t.string   "last_name",         :null => false
    t.integer  "year_of_birth",     :null => false
    t.integer  "number"
    t.time     "start_time"
    t.time     "arrival_time"
    t.integer  "shot1"
    t.integer  "shot2"
    t.integer  "shot3"
    t.integer  "shot4"
    t.integer  "shot5"
    t.integer  "shot6"
    t.integer  "shot7"
    t.integer  "shot8"
    t.integer  "shot9"
    t.integer  "shot10"
    t.integer  "shots_total_input"
    t.integer  "estimate1"
    t.integer  "estimate2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests", :force => true do |t|
    t.integer  "sport_id",   :null => false
    t.string   "name",       :null => false
    t.string   "location",   :null => false
    t.date     "start_date", :null => false
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.integer  "contest_id"
    t.string   "name",              :null => false
    t.integer  "correct_estimate1"
    t.integer  "correct_estimate2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sports", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "key",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
