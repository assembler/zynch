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

ActiveRecord::Schema.define(:version => 20110117150425) do

  create_table "accounts", :force => true do |t|
    t.string "name"
    t.string "domain"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "pages", :force => true do |t|
    t.string "title"
    t.text   "path"
    t.text   "search"
    t.string "charset", :limit => 45
  end

  create_table "pageviews", :id => false, :force => true do |t|
    t.integer   "id",         :null => false
    t.integer   "visit_id",   :null => false
    t.integer   "page_id",    :null => false
    t.timestamp "created_at"
  end

  add_index "pageviews", ["page_id"], :name => "fk_pageviews_pages1"
  add_index "pageviews", ["visit_id"], :name => "fk_pageviews_visits1"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visits", :id => false, :force => true do |t|
    t.integer   "id",                                                :null => false
    t.integer   "account_id",                                        :null => false
    t.integer   "entry_page_id",                                     :null => false
    t.integer   "exit_page_id",                                      :null => false
    t.string    "country_id",          :limit => 2,  :default => "", :null => false
    t.string    "ip_address",          :limit => 15
    t.integer   "pageviews_count"
    t.integer   "screen_width"
    t.integer   "screen_height"
    t.integer   "color_depth"
    t.integer   "flash_version"
    t.integer   "major_flash_version"
    t.string    "language",            :limit => 45
    t.string    "browser",             :limit => 45
    t.string    "browser_version",     :limit => 45
    t.string    "os",                  :limit => 45
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "visits", ["account_id"], :name => "fk_sessions_accounts"
  add_index "visits", ["country_id"], :name => "fk_visits_countries1"
  add_index "visits", ["entry_page_id"], :name => "fk_visits_pages1"
  add_index "visits", ["exit_page_id"], :name => "fk_visits_pages2"

end
