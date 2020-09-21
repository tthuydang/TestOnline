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

ActiveRecord::Schema.define(version: 2020_09_17_040926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "answer"
    t.boolean "is_correct"
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "delete_at"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "delete_at"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "histories", force: :cascade do |t|
    t.integer "total_question"
    t.integer "total_correct"
    t.boolean "is_passed"
    t.string "completed_time"
    t.bigint "user_id", null: false
    t.bigint "ticket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "delete_at"
    t.index ["ticket_id"], name: "index_histories_on_ticket_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "history_details", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "answer_id", null: false
    t.bigint "history_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["answer_id"], name: "index_history_details_on_answer_id"
    t.index ["history_id"], name: "index_history_details_on_history_id"
    t.index ["question_id"], name: "index_history_details_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "question"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "delete_at"
    t.index ["ticket_id"], name: "index_questions_on_ticket_id"
  end

  create_table "subtickets", force: :cascade do |t|
    t.string "code"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "result_ques"
    t.boolean "result_ans"
    t.text "content"
    t.index ["ticket_id"], name: "index_subtickets_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.string "image"
    t.text "description"
    t.datetime "max_time"
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "delete_at"
    t.datetime "start_date"
    t.datetime "finish_date"
    t.string "competition_code"
    t.index ["category_id"], name: "index_tickets_on_category_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "firstname"
    t.string "lastname"
    t.string "avatar"
    t.string "role_user"
    t.integer "user_id"
    t.datetime "delete_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "categories", "users"
  add_foreign_key "histories", "tickets"
  add_foreign_key "histories", "users"
  add_foreign_key "history_details", "answers"
  add_foreign_key "history_details", "histories"
  add_foreign_key "history_details", "questions"
  add_foreign_key "questions", "tickets"
  add_foreign_key "subtickets", "tickets"
  add_foreign_key "tickets", "categories"
  add_foreign_key "tickets", "users"
end
