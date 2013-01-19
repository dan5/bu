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

ActiveRecord::Schema.define(:version => 20130118152149) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["event_id"], :name => "index_comments_on_event_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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

  add_index "events", ["group_id"], :name => "index_events_on_group_id"

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

  add_index "member_requests", ["group_id"], :name => "index_member_requests_on_group_id"
  add_index "member_requests", ["user_id"], :name => "index_member_requests_on_user_id"

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

  add_index "posts", ["group_id"], :name => "index_posts_on_group_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_events", ["event_id"], :name => "index_user_events_on_event_id"
  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"

  create_table "user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "role"
  end

  add_index "user_groups", ["group_id"], :name => "index_user_groups_on_group_id"
  add_index "user_groups", ["user_id"], :name => "index_user_groups_on_user_id"

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
