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

ActiveRecord::Schema.define(version: 20140515054025) do

  create_table "admins", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "roles_mask"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "ads", force: true do |t|
    t.text     "content"
    t.integer  "weight"
    t.string   "link"
    t.integer  "counter"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", force: true do |t|
    t.string   "user_id"
    t.string   "course_id"
    t.string   "order_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "session_id"
    t.string   "order_number"
  end

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "click_records", force: true do |t|
    t.text     "url"
    t.string   "from"
    t.integer  "ad_id"
    t.text     "referer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_items", force: true do |t|
    t.integer  "course_id"
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "filename"
    t.integer  "day"
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "briefing"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "due_at"
    t.float    "price"
    t.integer  "duration_days"
    t.integer  "group_id"
    t.integer  "category_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "unit"
    t.string   "serial"
    t.string   "uuid"
  end

  create_table "groups", force: true do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inboxes", force: true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "publish_at"
    t.datetime "close_at"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: true do |t|
    t.string   "key"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "progresses", force: true do |t|
    t.integer  "study_id"
    t.integer  "course_id"
    t.integer  "course_item_id"
    t.integer  "user_id"
    t.integer  "day"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stage"
    t.integer  "phase"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "self_learnings", force: true do |t|
    t.integer  "user_id"
    t.string   "serial",      null: false
    t.string   "original"
    t.string   "translation"
    t.string   "word_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.string   "grouping_id"
  end

  create_table "seos", force: true do |t|
    t.integer  "obj_id"
    t.text     "description"
    t.text     "keyword"
    t.text     "title"
    t.text     "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_configs", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "key"
    t.text     "value"
  end

  create_table "studies", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "progress_id"
    t.integer  "status"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "score"
    t.date     "starts_at"
    t.date     "ends_at"
    t.integer  "passed"
    t.integer  "user_order_id"
    t.string   "contract_number"
    t.boolean  "activated",       default: false
    t.string   "uuid"
  end

  create_table "study_records", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_item_id"
    t.string   "content"
    t.integer  "study_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stage"
    t.integer  "phase"
    t.boolean  "wrong"
  end

  create_table "test", force: true do |t|
  end

  create_table "upload_files", force: true do |t|
    t.string   "title"
    t.string   "type"
    t.string   "path"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_orders", force: true do |t|
    t.integer  "user_id"
    t.string   "order_number"
    t.integer  "payment_method"
    t.integer  "payment_status"
    t.float    "payment_price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "courses"
    t.text     "notes"
    t.text     "note"
  end

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "middlename"
    t.string   "id_number"
    t.date     "dob"
    t.integer  "gender"
    t.string   "education"
    t.string   "country"
    t.string   "state"
    t.string   "register_address"
    t.string   "address"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "cellphone"
    t.string   "phone"
  end

  add_index "user_profiles", ["firstname", "lastname"], name: "index_user_profiles_firstname_lastname", type: :fulltext
  add_index "user_profiles", ["firstname"], name: "index_user_profiles_firstname", type: :fulltext
  add_index "user_profiles", ["lastname", "firstname", "id_number", "education", "country", "address"], name: "index_user_profiles", type: :fulltext
  add_index "user_profiles", ["lastname"], name: "index_user_profiles_lastname", type: :fulltext

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "roles_mask"
    t.string   "type"
    t.boolean  "activated"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "serial_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_email", type: :fulltext
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
