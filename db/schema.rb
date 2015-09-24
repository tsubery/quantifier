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

ActiveRecord::Schema.define(version: 20150909225051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", id: false, force: :cascade do |t|
    t.string   "beeminder_token",   null: false
    t.string   "beeminder_user_id", null: false, index: {name: "index_users_on_beeminder_user_id", unique: true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials", force: :cascade do |t|
    t.string   "beeminder_user_id", null: false, foreign_key: {references: "users", primary_key: "beeminder_user_id", name: "fk_credentials_beeminder_user_id", on_update: :no_action, on_delete: :no_action}
    t.string   "provider_name",     null: false, index: {name: "index_credentials_on_provider_name_and_beeminder_user_id", with: ["beeminder_user_id"], unique: true}
    t.string   "uid",               default: "", null: false
    t.json     "info",              default: {}, null: false
    t.json     "credentials",       default: {}, null: false
    t.json     "extra",             default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index "credentials", ["provider_name", "uid"], name: "index_credentials_on_provider_name_and_uid", unique: true

  create_table "goals", force: :cascade do |t|
    t.integer "credential_id", null: false, index: {name: "fk__goals_provider_id"}, foreign_key: {references: "credentials", name: "fk_goals_provider_id", on_update: :no_action, on_delete: :no_action}
    t.string  "slug",          null: false, index: {name: "index_goals_on_slug_and_credential_id", with: ["credential_id"], unique: true}
    t.float   "last_value"
    t.json    "params",        default: {}, null: false
    t.string  "metric_key",    null: false, index: {name: "index_goals_on_metric_key"}
  end

  create_table "scores", force: :cascade do |t|
    t.float    "value",        null: false
    t.datetime "timestamp",    null: false
    t.string   "datapoint_id"
    t.integer  "goal_id",      index: {name: "index_scores_on_goal_id"}, foreign_key: {references: "goals", name: "fk_scores_goal_id", on_update: :no_action, on_delete: :no_action}
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index "scores", ["goal_id", "timestamp"], name: "index_scores_on_goal_id_and_timestamp", unique: true

end
