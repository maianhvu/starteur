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

ActiveRecord::Schema.define(version: 20151006125103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "access_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "test_id"
    t.datetime "last_used_at"
    t.boolean  "universal"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "access_codes", ["test_id"], name: "index_access_codes_on_test_id", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.string   "name"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "test_id"
    t.integer  "question_id"
    t.integer  "value"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["test_id"], name: "index_answers_on_test_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "last_used_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "state",        default: 1
  end

  add_index "authentication_tokens", ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree

  create_table "batch_user", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "batch_user", ["batch_id"], name: "index_batch_user_on_batch_id", using: :btree
  add_index "batch_user", ["user_id"], name: "index_batch_user_on_user_id", using: :btree

  create_table "batches", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "rank"
    t.string   "title"
    t.text     "description"
    t.integer  "test_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "symbol"
  end

  add_index "categories", ["test_id"], name: "index_categories_on_test_id", using: :btree

  create_table "code_usages", force: :cascade do |t|
    t.integer  "access_code_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "state"
  end

  add_index "code_usages", ["access_code_id"], name: "index_code_usages_on_access_code_id", using: :btree
  add_index "code_usages", ["user_id"], name: "index_code_usages_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "street_address"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "ordinal"
    t.string   "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "category_id"
    t.string   "choices",                              array: true
    t.integer  "polarity",    default: 1
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["choices"], name: "index_questions_on_choices", using: :gin

  create_table "results", force: :cascade do |t|
    t.hstore  "answers"
    t.integer "user_id"
    t.integer "test_id"
    t.integer "code_usage_id"
  end

  add_index "results", ["code_usage_id"], name: "index_results_on_code_usage_id", using: :btree
  add_index "results", ["test_id"], name: "index_results_on_test_id", using: :btree
  add_index "results", ["user_id"], name: "index_results_on_user_id", using: :btree

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "state",       default: 1
    t.float    "price",       default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "shuffle",     default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "type"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.boolean  "deactivated"
    t.integer  "state",                           default: 1
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  add_foreign_key "access_codes", "tests"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "tests"
  add_foreign_key "answers", "users"
  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "batch_user", "batches"
  add_foreign_key "batch_user", "users"
  add_foreign_key "categories", "tests"
  add_foreign_key "code_usages", "access_codes"
  add_foreign_key "code_usages", "users"
  add_foreign_key "questions", "categories"
  add_foreign_key "results", "code_usages"
  add_foreign_key "results", "tests"
  add_foreign_key "results", "users"
end
