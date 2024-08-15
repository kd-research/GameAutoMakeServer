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

ActiveRecord::Schema[7.1].define(version: 2024_08_14_152427) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "conversations", force: :cascade do |t|
    t.text "system_message"
    t.integer "previous_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["previous_id"], name: "index_conversations_on_previous_id"
  end

  create_table "conversations_dialogs", id: false, force: :cascade do |t|
    t.integer "conversation_id", null: false
    t.integer "dialog_id", null: false
  end

  create_table "dialogs", force: :cascade do |t|
    t.string "request_role"
    t.text "request_message"
    t.string "response_role"
    t.text "response_message"
    t.integer "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_dialogs_on_conversation_id", unique: true
  end

  create_table "game_compiles", force: :cascade do |t|
    t.integer "game_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gameable_id"
    t.string "gameable_type"
    t.integer "status"
    t.text "compile_log"
    t.index ["game_project_id"], name: "index_game_compiles_on_game_project_id", unique: true
  end

  create_table "game_projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "privacy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "chat_conversation_id", null: false
    t.integer "game_generate_conversation_id"
    t.string "compile_type", default: "unity"
    t.text "chat_agent_instruction"
    t.text "summary_agent_instruction"
    t.text "summary_agent_task"
    t.index ["chat_conversation_id"], name: "index_game_projects_on_chat_conversation_id"
    t.index ["game_generate_conversation_id"], name: "index_game_projects_on_game_generate_conversation_id"
    t.index ["user_id"], name: "index_game_projects_on_user_id"
  end

  create_table "html_game_compiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "model_type"
  end

  create_table "user_oauths", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_oauths_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webgl_game_compiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "conversations", "conversations", column: "previous_id"
  add_foreign_key "dialogs", "conversations"
  add_foreign_key "game_compiles", "game_projects"
  add_foreign_key "game_projects", "conversations", column: "chat_conversation_id"
  add_foreign_key "game_projects", "conversations", column: "game_generate_conversation_id"
  add_foreign_key "game_projects", "users"
  add_foreign_key "user_oauths", "users"
  add_foreign_key "user_profiles", "users"
end
