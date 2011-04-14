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
    t.integer   "action_id",  :null => false
    t.integer   "answer_id",  :null => false
    t.timestamp "created_at", :null => false
  end

  create_table "actions", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "answer_details", :id => false, :force => true do |t|
    t.integer "letter_id",                         :null => false
    t.integer "letter_details_id",                 :null => false
    t.string  "supplier",          :default => "", :null => false
    t.integer "received_drugs",                    :null => false
    t.integer "identified_drugs",                  :null => false
    t.string  "details",           :default => "", :null => false
  end

  create_table "boxing_types", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string "name", :limit => 100, :default => "", :null => false
  end

  create_table "letter_details", :force => true do |t|
    t.integer "letter_id",                       :null => false
    t.integer "medicine_id",                     :null => false
    t.integer "boxing_type_id",                  :null => false
    t.integer "measure_id",                      :null => false
    t.integer "manufacturer_id",                 :null => false
    t.integer "country_id",                      :null => false
    t.string  "serial",          :default => "", :null => false
  end

  create_table "letters", :force => true do |t|
    t.string    "item",       :default => "", :null => false
    t.timestamp "created_on",                 :null => false
    t.integer   "state_id",                   :null => false
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

  create_table "organization_details", :id => false, :force => true do |t|
    t.integer "organization_id",                                :null => false
    t.string  "quality_contol",                 :default => "", :null => false
    t.string  "phone",           :limit => 100, :default => "", :null => false
  end

  add_index "organization_details", ["organization_id"], :name => "organization_id"

  create_table "organizations", :force => true do |t|
    t.integer "parent_id",                 :null => false
    t.string  "name",      :default => "", :null => false
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

  create_table "states", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer "role_id",                                              :null => false
    t.integer "organization_id",                                      :null => false
    t.string  "email"
    t.string  "encrypted_password", :limit => 128
    t.string  "salt",               :limit => 128
    t.string  "confirmation_token", :limit => 128
    t.string  "remember_token",     :limit => 128
    t.boolean "email_confirmed",                   :default => false, :null => false
    t.boolean "admin",                             :default => false
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
