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

ActiveRecord::Schema[7.1].define(version: 2025_09_22_000300) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "sleep_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "slept_at", null: false
    t.datetime "woke_at"
    t.integer "duration_sec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "slept_at"], name: "index_sleep_sessions_on_user_id_and_slept_at"
    t.index ["user_id", "woke_at"], name: "index_sleep_sessions_on_user_id_and_woke_at"
    t.index ["user_id"], name: "idx_unique_open_sleep_session", unique: true, where: "(woke_at IS NULL)"
    t.index ["woke_at"], name: "index_sleep_sessions_on_woke_at"
    t.check_constraint "woke_at IS NULL OR slept_at < woke_at", name: "slept_before_woke"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "sleep_sessions", "users"
end
