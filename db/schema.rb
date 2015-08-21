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

ActiveRecord::Schema.define(version: 20150821213619) do

  create_table "api_responses", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "carrier",           null: false
    t.integer  "total_price",       null: false
    t.string   "service_type",      null: false
    t.datetime "expected_delivery"
    t.string   "tracking_number"
  end

  create_table "destinations", force: :cascade do |t|
    t.string   "country",         default: "US", null: false
    t.string   "state",                          null: false
    t.string   "city",                           null: false
    t.string   "zip",                            null: false
    t.integer  "api_response_id",                null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "order_id"
  end

  add_index "destinations", ["api_response_id"], name: "index_destinations_on_api_response_id"

  create_table "origins", force: :cascade do |t|
    t.string   "country",         default: "US", null: false
    t.string   "state",                          null: false
    t.string   "city",                           null: false
    t.string   "zip",                            null: false
    t.integer  "api_response_id",                null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "origins", ["api_response_id"], name: "index_origins_on_api_response_id"

  create_table "packages", force: :cascade do |t|
    t.float    "weight",          null: false
    t.float    "height",          null: false
    t.float    "width",           null: false
    t.float    "depth"
    t.integer  "api_response_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "product_id"
  end

  add_index "packages", ["api_response_id"], name: "index_packages_on_api_response_id"

end
