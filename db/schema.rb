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

ActiveRecord::Schema.define(version: 20160511084142) do

  create_table "original_urls", force: :cascade do |t|
    t.string   "long_url"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "clicks",     default: 0
  end

  create_table "short_urls", force: :cascade do |t|
    t.string   "vanity_string"
    t.integer  "original_url_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "short_urls", ["vanity_string"], name: "index_short_urls_on_vanity_string", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image_url"
    t.string   "url"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "total_clicks", default: 0
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["uid"], name: "index_users_on_uid"

end
