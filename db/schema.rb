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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120425074614) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "group_id"
    t.string   "title"
    t.string   "place"
    t.string   "address"
    t.integer  "limit"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text     "description"
    t.boolean  "ended",         :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "owner_user_id"
    t.string   "image_url"
    t.boolean  "canceled",      :default => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "owner_user_id"
    t.string   "name"
    t.text     "description"
    t.integer  "permission",    :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "summary"
    t.string   "image_url"
    t.boolean  "hidden"
  end

  create_table "member_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "idx"
    t.integer  "notification"
    t.text     "subject"
    t.text     "text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "role"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "mail"
    t.string   "image"
  end

end
