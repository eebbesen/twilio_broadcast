# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_06_220220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "message_recipient_lists", force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "recipient_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id"], name: "index_message_recipient_lists_on_message_id"
    t.index ["recipient_list_id"], name: "index_message_recipient_lists_on_recipient_list_id"
  end

  create_table "message_recipients", force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "recipient_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.integer "error_code"
    t.string "error_message"
    t.index ["message_id"], name: "index_message_recipients_on_message_id"
    t.index ["recipient_id"], name: "index_message_recipients_on_recipient_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.string "status"
    t.datetime "sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "recipient_list_members", force: :cascade do |t|
    t.integer "recipient_id", null: false
    t.integer "recipient_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipient_id"], name: "index_recipient_list_members_on_recipient_id"
    t.index ["recipient_list_id"], name: "index_recipient_list_members_on_recipient_list_id"
  end

  create_table "recipient_lists", force: :cascade do |t|
    t.string "name"
    t.string "notes"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recipients", force: :cascade do |t|
    t.string "phone"
    t.string "email"
    t.string "name"
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "message_recipient_lists", "messages"
  add_foreign_key "message_recipient_lists", "recipient_lists"
  add_foreign_key "message_recipients", "messages"
  add_foreign_key "message_recipients", "recipients"
  add_foreign_key "recipient_list_members", "recipient_lists"
  add_foreign_key "recipient_list_members", "recipients"
end
