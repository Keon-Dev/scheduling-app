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

ActiveRecord::Schema[8.1].define(version: 2026_10_04_043534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.datetime "confirmed_end_at"
    t.bigint "confirmed_slot_id"
    t.datetime "confirmed_start_at"
    t.datetime "created_at", null: false
    t.datetime "deadline"
    t.text "description"
    t.boolean "editable_by_anyone", default: true, null: false
    t.integer "expected_participant_count"
    t.integer "granularity", default: 0, null: false
    t.bigint "owner_user_id"
    t.string "public_token", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_user_id"], name: "index_events_on_owner_user_id"
    t.index ["public_token"], name: "index_events_on_public_token", unique: true
  end

  create_table "slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_at", null: false
    t.bigint "event_id", null: false
    t.datetime "start_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "start_at"], name: "index_slots_on_event_id_and_start_at", unique: true
    t.index ["event_id"], name: "index_slots_on_event_id"
  end

  create_table "user_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "workspace_id"
    t.index ["provider", "uid", "workspace_id"], name: "index_user_identities_on_provider_and_uid_and_workspace_id", unique: true, nulls_not_distinct: true
    t.index ["user_id", "provider", "workspace_id"], name: "index_user_identities_on_user_id_and_provider_and_workspace_id", unique: true, nulls_not_distinct: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "stripe_customer_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", unique: true
  end

  add_foreign_key "events", "slots", column: "confirmed_slot_id", on_delete: :nullify
  add_foreign_key "events", "users", column: "owner_user_id", on_delete: :nullify
  add_foreign_key "slots", "events", on_delete: :cascade
  add_foreign_key "user_identities", "users", on_delete: :cascade
end
