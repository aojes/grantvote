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

ActiveRecord::Schema.define(:version => 11) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "credits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "laurels",    :default => 0, :null => false
    t.integer  "ribbons",    :default => 0, :null => false
    t.integer  "pearls",     :default => 0, :null => false
    t.integer  "shells",     :default => 0, :null => false
    t.integer  "pebbles",    :default => 0, :null => false
    t.integer  "beads",      :default => 0, :null => false
    t.integer  "buttons",    :default => 0, :null => false
    t.integer  "pens",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["user_id"], :name => "index_credits_on_user_id"

  create_table "grants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "name"
    t.text     "proposal"
    t.boolean  "final",              :default => false, :null => false
    t.boolean  "awarded",            :default => false, :null => false
    t.integer  "amount",             :default => 10,    :null => false
    t.string   "permalink"
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
    t.integer  "dues",                                             :default => 2,   :null => false
    t.decimal  "funds",              :precision => 9, :scale => 2, :default => 0.0, :null => false
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "groups", ["name"], :name => "index_groups_on_name"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "interest"
    t.string   "role",       :default => "basic", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], :name => "index_memberships_on_group_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "login"
    t.string   "name"
    t.text     "detail"
    t.string   "link"
    t.string   "location"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

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

  add_index "votes", ["group_id", "grant_id"], :name => "index_votes_on_group_id_and_grant_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
