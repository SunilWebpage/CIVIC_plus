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

ActiveRecord::Schema[8.1].define(version: 2026_04_01_113100) do
  create_table "answer_sheets", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.text "answers_text", null: false
    t.datetime "created_at", null: false
    t.bigint "exam_practice_id", null: false
    t.datetime "submitted_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["exam_practice_id"], name: "index_answer_sheets_on_exam_practice_id"
    t.index ["user_id"], name: "index_answer_sheets_on_user_id"
  end

  create_table "books", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "pdf_url"
    t.integer "standard", null: false
    t.string "subject", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["standard", "subject"], name: "index_books_on_standard_and_subject", unique: true
  end

  create_table "exam_practices", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration_minutes", null: false
    t.string "exam_type", null: false
    t.text "instructions"
    t.text "questions_text", null: false
    t.string "subject", null: false
    t.string "title", null: false
    t.integer "total_marks", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_papers", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.boolean "is_premium"
    t.string "pdf_url"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.boolean "advance", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "free", default: true, null: false
    t.string "password_digest", null: false
    t.boolean "pro", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answer_sheets", "exam_practices"
  add_foreign_key "answer_sheets", "users"
end
