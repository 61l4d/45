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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161017233740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "friend_id",               null: false
    t.datetime "last_read_friend_update"
    t.datetime "last_read_user_update"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string  "name"
    t.integer "region_id"
    t.index ["region_id"], name: "index_countries_on_region_id", using: :btree
  end

  create_table "divisions", force: :cascade do |t|
    t.string  "name"
    t.integer "country_id"
    t.index ["country_id"], name: "index_divisions_on_country_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "fb_id"
    t.string   "se_id"
    t.text     "ip_addresses"
    t.text     "geolocations"
    t.text     "preferences"
    t.integer  "region_id"
    t.integer  "country_id"
    t.integer  "division_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["country_id"], name: "index_users_on_country_id", using: :btree
    t.index ["division_id"], name: "index_users_on_division_id", using: :btree
    t.index ["region_id"], name: "index_users_on_region_id", using: :btree
  end

  add_foreign_key "countries", "regions"
  add_foreign_key "divisions", "countries"
  add_foreign_key "users", "countries"
  add_foreign_key "users", "divisions"
  add_foreign_key "users", "regions"
end
