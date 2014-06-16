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

ActiveRecord::Schema.define(:version => 20140616000214) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "connections", :force => true do |t|
    t.integer  "connecter_id"
    t.integer  "connectee_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "connections", ["connectee_id"], :name => "index_connections_on_connectee_id"
  add_index "connections", ["connecter_id"], :name => "index_connections_on_connecter_id"

  create_table "keywords", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "keywords_posts", :force => true do |t|
    t.integer  "keyword_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "keywords_posts", ["keyword_id"], :name => "index_keywords_posts_on_keyword_id"
  add_index "keywords_posts", ["post_id"], :name => "index_keywords_posts_on_post_id"

  create_table "matches", :force => true do |t|
    t.integer  "post_id"
    t.integer  "matching_id"
    t.integer  "keyword_coverage"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "matches", ["matching_id"], :name => "index_matches_on_matching_id"
  add_index "matches", ["post_id"], :name => "index_matches_on_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "category_id"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.date     "expiration"
    t.string   "range"
    t.boolean  "alert"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "image"
    t.string   "city"
    t.string   "postcode"
    t.text     "bio"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
