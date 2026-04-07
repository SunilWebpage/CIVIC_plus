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

ActiveRecord::Schema[8.1].define(version: 2026_04_07_121000) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "syllabuses", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "exam_name", null: false
    t.string "pdf_url", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "exam_name"], name: "index_syllabuses_on_category_and_exam_name", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answer_sheets", "exam_practices"
  add_foreign_key "answer_sheets", "users"
end
