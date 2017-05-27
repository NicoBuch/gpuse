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

ActiveRecord::Schema.define(version: 20170527180303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "frames", force: :cascade do |t|
    t.integer  "published_code_id"
    t.integer  "index"
    t.string   "file"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "completed",         default: false
    t.bigint   "time_elapsed"
    t.bigint   "weis_earned"
    t.index ["published_code_id"], name: "index_frames_on_published_code_id", using: :btree
  end

  create_table "published_codes", force: :cascade do |t|
    t.text     "code"
    t.integer  "publisher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["publisher_id"], name: "index_published_codes_on_publisher_id", using: :btree
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "username",    null: false
    t.string   "password",    null: false
    t.string   "eth_address"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["username"], name: "index_publishers_on_username", unique: true, using: :btree
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "eth_address"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "frames", "published_codes"
  add_foreign_key "published_codes", "publishers"
end
