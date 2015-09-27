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

ActiveRecord::Schema.define(version: 20150927035054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "answers", force: :cascade do |t|
    t.integer  "choice_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "answers", ["choice_id"], name: "index_answers_on_choice_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "last_used_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "state"
  end

  add_index "authentication_tokens", ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "rank"
    t.string   "title"
    t.text     "description"
    t.integer  "test_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categories", ["test_id"], name: "index_categories_on_test_id", using: :btree

  create_table "choices", force: :cascade do |t|
    t.string  "content"
    t.integer "points"
    t.integer "ordinal"
    t.integer "question_id"
  end

  add_index "choices", ["question_id"], name: "index_choices_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "ordinal"
    t.string   "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.hstore  "answers"
    t.integer "user_id"
    t.integer "test_id"
  end

  add_index "results", ["test_id"], name: "index_results_on_test_id", using: :btree
  add_index "results", ["user_id"], name: "index_results_on_user_id", using: :btree

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "state"
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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.boolean  "deactivated"
    t.string   "state"
  end

  add_foreign_key "answers", "choices"
  add_foreign_key "answers", "users"
  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "categories", "tests"
  add_foreign_key "choices", "questions"
  add_foreign_key "questions", "categories"
  add_foreign_key "results", "tests"
  add_foreign_key "results", "users"
end
