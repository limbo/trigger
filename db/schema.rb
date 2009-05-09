# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 15) do

  create_table "accounts", :force => true do |t|
    t.integer "owner_id"
    t.integer "remote_id"
    t.string  "login"
    t.string  "password"
    t.integer "last_msg_id"
    t.string  "profile_image_url"
    t.integer "last_group_id",     :default => 0
    t.string  "token"
    t.string  "secret"
  end

  create_table "accounts_groups", :id => false, :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "group_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_filters", :force => true do |t|
    t.string   "type"
    t.string   "filter_name"
    t.integer  "owner_id"
    t.string   "query"
    t.integer  "is_default",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :id => false, :force => true do |t|
    t.integer  "follower_id", :null => false
    t.integer  "followed_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "updates", :force => true do |t|
    t.integer  "message_id"
    t.integer  "sender_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_mention",             :default => 0
    t.integer  "in_reply_to_account_id"
    t.integer  "in_reply_to_update_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "last_account_id"
  end

end
