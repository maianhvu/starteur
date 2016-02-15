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

ActiveRecord::Schema.define(version: 20160214030220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "test_id"
    t.datetime "last_used_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "educator_id"
    t.integer  "permits",           default: 1
    t.integer  "code_usages_count", default: 0, null: false
  end

  add_index "access_codes", ["test_id"], name: "index_access_codes_on_test_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "test_id"
    t.integer "question_id"
    t.integer "value"
    t.integer "result_id"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["result_id"], name: "index_answers_on_result_id", using: :btree
  add_index "answers", ["test_id"], name: "index_answers_on_test_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "batch_code_usages", force: :cascade do |t|
    t.integer "batch_id"
    t.integer "code_usage_id"
    t.boolean "own",           default: false
  end

  create_table "batches", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "test_id"
    t.integer  "educator_id"
    t.string   "email",       default: [],              array: true
    t.string   "name"
  end

  create_table "batches_coeducators", id: false, force: :cascade do |t|
    t.integer "batch_id"
    t.integer "educator_id"
  end

  add_index "batches_coeducators", ["batch_id", "educator_id"], name: "index_batches_coeducators_on_batch_id_and_educator_id", unique: true, using: :btree
  add_index "batches_coeducators", ["batch_id"], name: "index_batches_coeducators_on_batch_id", using: :btree
  add_index "batches_coeducators", ["educator_id"], name: "index_batches_coeducators_on_educator_id", using: :btree

  create_table "batches_results", id: false, force: :cascade do |t|
    t.integer "batch_id"
    t.integer "result_id"
  end

  add_index "batches_results", ["batch_id"], name: "index_batches_results_on_batch_id", using: :btree
  add_index "batches_results", ["result_id"], name: "index_batches_results_on_result_id", using: :btree

  create_table "billing_line_items", force: :cascade do |t|
    t.integer  "test_id"
    t.integer  "billing_record_id"
    t.integer  "quantity"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "billing_records", force: :cascade do |t|
    t.string   "bill_number"
    t.integer  "billable_id"
    t.string   "billable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
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
    t.string   "email"
    t.string   "uuid"
    t.integer  "test_id"
  end

  add_index "code_usages", ["access_code_id"], name: "index_code_usages_on_access_code_id", using: :btree
  add_index "code_usages", ["test_id"], name: "index_code_usages_on_test_id", using: :btree
  add_index "code_usages", ["user_id"], name: "index_code_usages_on_user_id", using: :btree

  create_table "discount_codes", force: :cascade do |t|
    t.integer  "billing_record_id"
    t.string   "code"
    t.integer  "state"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "educators", force: :cascade do |t|
    t.string   "email",                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.integer  "state"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "last_name"
    t.string   "organization"
    t.string   "title"
    t.string   "secondary_email"
  end

  add_index "educators", ["email"], name: "index_educators_on_email", unique: true, using: :btree
  add_index "educators", ["reset_password_token"], name: "index_educators_on_reset_password_token", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "promotion_codes", force: :cascade do |t|
    t.integer  "billing_record_id"
    t.string   "code"
    t.integer  "state"
    t.integer  "test_id"
    t.integer  "access_code_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "ordinal"
    t.string   "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "category_id"
    t.string   "choices",                              array: true
    t.integer  "polarity",    default: 1
    t.integer  "scale"
    t.integer  "test_id"
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["choices"], name: "index_questions_on_choices", using: :gin
  add_index "questions", ["test_id"], name: "index_questions_on_test_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "test_id"
    t.integer  "code_usage_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "results", ["code_usage_id"], name: "index_results_on_code_usage_id", using: :btree
  add_index "results", ["test_id"], name: "index_results_on_test_id", using: :btree
  add_index "results", ["user_id"], name: "index_results_on_user_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer "user_id"
    t.integer "test_id"
    t.integer "result_id"
    t.integer "value"
    t.integer "upon",        default: 100
    t.integer "category_id"
  end

  add_index "scores", ["category_id"], name: "index_scores_on_category_id", using: :btree
  add_index "scores", ["result_id"], name: "index_scores_on_result_id", using: :btree
  add_index "scores", ["test_id"], name: "index_scores_on_test_id", using: :btree
  add_index "scores", ["user_id"], name: "index_scores_on_user_id", using: :btree

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "state",          default: 1
    t.float    "price",          default: 0.0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "shuffle",        default: false
    t.string   "processor_file"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "type"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.boolean  "deactivated"
    t.integer  "state",                        default: 1
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "access_codes", "tests"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "tests"
  add_foreign_key "answers", "users"
  add_foreign_key "batches_coeducators", "batches"
  add_foreign_key "batches_coeducators", "educators"
  add_foreign_key "batches_results", "batches"
  add_foreign_key "batches_results", "results"
  add_foreign_key "categories", "tests"
  add_foreign_key "code_usages", "access_codes"
  add_foreign_key "code_usages", "tests"
  add_foreign_key "code_usages", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "questions", "categories"
  add_foreign_key "questions", "tests"
  add_foreign_key "results", "code_usages"
  add_foreign_key "results", "tests"
  add_foreign_key "results", "users"
  add_foreign_key "scores", "categories"
  add_foreign_key "scores", "results"
  add_foreign_key "scores", "tests"
  add_foreign_key "scores", "users"
end
