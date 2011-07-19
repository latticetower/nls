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

ActiveRecord::Schema.define(:version => 20110412112347) do

  create_table "action_lists", :id => false, :force => true do |t|
    t.integer  "tactic_id",        :null => false
    t.integer  "answer_detail_id", :null => false
    t.datetime "created_at",       :null => false
  end

  create_table "answer_details", :force => true do |t|
    t.integer "letter_id",        :default => 0,  :null => false
    t.integer "letter_detail_id",                 :null => false
    t.string  "supplier_name",    :default => "", :null => false
    t.integer "received_drugs",   :default => 0,  :null => false
    t.integer "identified_drugs", :default => 0,  :null => false
    t.string  "details",          :default => "", :null => false
    t.integer "organization_id",  :default => 0
    t.integer "tactic_id",        :default => 0
    t.integer "answer_id"
    t.integer "user_id"
    t.integer "supplier_id"
  end

  create_table "answers", :force => true do |t|
    t.integer "user_id"
    t.boolean "answered",    :default => false
    t.date    "answer_date"
    t.integer "letter_id"
  end

  create_table "boxing_types", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string "name", :limit => 100, :default => "", :null => false
  end

  create_table "detail_types", :force => true do |t|
    t.string  "name"
    t.string  "name_long"
    t.integer "group"
  end

  create_table "history_logs", :force => true do |t|
    t.time    "created_at"
    t.string  "email"
    t.string  "password"
    t.string  "ip",         :limit => 25
    t.text    "useragent"
    t.boolean "allowed",                  :default => false
  end

  create_table "letter_details", :force => true do |t|
    t.integer "letter_id",                       :null => false
    t.integer "medicine_id",     :default => 0,  :null => false
    t.integer "boxing_type_id",  :default => 0,  :null => false
    t.integer "measure_id",      :default => 0,  :null => false
    t.integer "manufacturer_id", :default => 0,  :null => false
    t.integer "country_id",      :default => 0,  :null => false
    t.string  "serial",          :default => "", :null => false
    t.integer "detail_type_id"
  end

  create_table "letter_states", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "letters", :force => true do |t|
    t.string   "item",            :default => "", :null => false
    t.datetime "created_on",                      :null => false
    t.integer  "state_id",        :default => 1,  :null => false
    t.integer  "organization_id", :default => 0,  :null => false
    t.date     "item_date"
    t.date     "updated_on"
  end

  create_table "manufacturers", :force => true do |t|
    t.string "name", :limit => 100, :default => "", :null => false
  end

  create_table "measures", :force => true do |t|
    t.string "name", :limit => 100, :default => "", :null => false
  end

  create_table "medicines", :force => true do |t|
    t.string "name",                      :default => "", :null => false
    t.string "name_short", :limit => 100, :default => "", :null => false
  end

  create_table "organization_details", :force => true do |t|
    t.string  "phone",           :limit => 100, :default => "", :null => false
    t.integer "organization_id"
    t.string  "quality_control"
  end

  create_table "organizations", :force => true do |t|
    t.integer "parent_id", :default => 0,  :null => false
    t.string  "name",      :default => "", :null => false
    t.string  "name_long", :default => "", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string "name",        :limit => 100, :default => "", :null => false
    t.string "description",                :default => "", :null => false
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "role_id",       :null => false
    t.integer "permission_id", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name",     :default => "", :null => false
    t.string "typename", :default => "", :null => false
  end

  create_table "suppliers", :id => false, :force => true do |t|
    t.integer "id",   :null => false
    t.string  "name"
  end

  create_table "tactics", :force => true do |t|
    t.string  "name",  :default => "", :null => false
    t.integer "group"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id",                           :default => 5,     :null => false
    t.integer  "organization_id",                   :default => 1,     :null => false
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.boolean  "email_confirmed",                   :default => false, :null => false
    t.boolean  "admin",                             :default => false
    t.string   "organization_name"
    t.boolean  "active",                            :default => false
    t.string   "upoln_name"
    t.string   "phone"
    t.datetime "registered_at"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
