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

ActiveRecord::Schema.define(:version => 20091102164509) do

  create_table "anisette_commits", :force => true do |t|
    t.string   "sha"
    t.text     "log"
    t.integer  "branch_id"
    t.integer  "author_id"
    t.string   "author_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "commited_time"
  end

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.integer  "repository_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bugs", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "repository_id"
    t.integer  "branch_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.integer  "local_id",      :default => 0
    t.integer  "fix_id",        :default => 0
  end

  create_table "events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_type"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "repositories", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "talks", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "parent_id",  :default => 0
    t.integer  "bug_id"
    t.integer  "commit_id"
    t.string   "action"
    t.string   "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",             :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "login"
    t.string   "crypted_password"
    t.string   "remember_token"
  end

end
