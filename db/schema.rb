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

ActiveRecord::Schema.define(:version => 20120213093204) do

  create_table "jobs", :force => true do |t|
    t.string   "task"
    t.text     "notes"
    t.text     "results"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.datetime "completed_at"
    t.string   "stage"
    t.datetime "deleted_at"
    t.boolean  "success",      :default => true
    t.string   "verbosity",    :default => "v"
  end

  create_table "projects", :force => true do |t|
    t.string   "url"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.text     "github_data"
    t.datetime "cloned_at"
    t.datetime "deleted_at"
    t.boolean  "pull_in_progress",   :default => false
    t.datetime "pulled_at"
    t.integer  "job_in_progress_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "github_access_token"
    t.text     "github_data"
    t.boolean  "ssh_key_uploaded_to_github", :default => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.datetime "deleted_at"
    t.string   "token"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

end
