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

ActiveRecord::Schema.define(:version => 8) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "name"
    t.text     "proposal"
    t.boolean  "final",                                            :default => false, :null => false
    t.boolean  "awarded",                                          :default => false, :null => false
    t.decimal  "amount",             :precision => 9, :scale => 2, :default => 0.0,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "grants", ["group_id"], :name => "index_grants_on_group_id"
  add_index "grants", ["user_id"], :name => "index_grants_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "purpose"
    t.integer  "members"
    t.integer  "dues",                                             :default => 2,   :null => false
    t.decimal  "funds",              :precision => 9, :scale => 2, :default => 0.0, :null => false
    t.integer  "wait",                                             :default => 7,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "interest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["interest"], :name => "index_memberships_on_interest"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",   :default => "", :null => false
    t.string   "email",              :default => "", :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

  create_table "votes", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "group_id",   :null => false
    t.integer  "grant_id",   :null => false
    t.string   "cast",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["grant_id"], :name => "index_votes_on_grant_id"
  add_index "votes", ["group_id"], :name => "index_votes_on_group_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
