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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150719185636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goals", force: :cascade do |t|
    t.integer "provider_id", null: false
    t.string  "slug",        null: false
    t.float   "last_value"
  end

  add_index "goals", ["slug", "provider_id"], name: "index_goals_on_slug_and_provider_id", unique: true, using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "beeminder_user_id",              null: false
    t.string   "name",                           null: false
    t.string   "uid",               default: "", null: false
    t.json     "info",              default: {}, null: false
    t.json     "credentials",       default: {}, null: false
    t.json     "extra",             default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "providers", ["name", "beeminder_user_id"], name: "index_providers_on_name_and_beeminder_user_id", unique: true, using: :btree
  add_index "providers", ["name", "uid"], name: "index_providers_on_name_and_uid", unique: true, using: :btree

  create_table "users", id: false, force: :cascade do |t|
    t.string   "beeminder_token",   null: false
    t.string   "beeminder_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["beeminder_user_id"], name: "index_users_on_beeminder_user_id", unique: true, using: :btree

  add_foreign_key "goals", "providers"
  add_foreign_key "providers", "users", column: "beeminder_user_id", primary_key: "beeminder_user_id"
end
