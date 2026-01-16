# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_16_124323) do
  create_table "monitored_endpoint_checks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "latency"
    t.integer "monitored_endpoint_id", null: false
    t.integer "response_code"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["monitored_endpoint_id"], name: "index_monitored_endpoint_checks_on_monitored_endpoint_id"
  end

  create_table "monitored_endpoints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "interval"
    t.integer "lock_version", default: 0, null: false
    t.datetime "next_launch_at"
    t.string "status", default: "pending"
    t.integer "threshold"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  add_foreign_key "monitored_endpoint_checks", "monitored_endpoints"
end
