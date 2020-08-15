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

ActiveRecord::Schema.define(version: 2020_08_15_074012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "answer"
    t.boolean "is_correct"
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer "total_correct"
    t.integer "total_question"
    t.boolean "is_passed"
    t.datetime "completed_time"
    t.bigint "user_id", null: false
    t.bigint "ticket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_id"], name: "index_histories_on_ticket_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "question"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_id"], name: "index_questions_on_ticket_id"
  end

  create_table "sub_tickets", force: :cascade do |t|
    t.string "code"
    t.text "content"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_id"], name: "index_sub_tickets_on_ticket_id"
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
    t.index ["category_id"], name: "index_tickets_on_category_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "password_digest"
    t.string "avatar"
    t.string "type"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "histories", "tickets"
  add_foreign_key "histories", "users"
  add_foreign_key "questions", "tickets"
  add_foreign_key "sub_tickets", "tickets"
  add_foreign_key "tickets", "categories"
  add_foreign_key "tickets", "users"
end
