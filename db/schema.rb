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

ActiveRecord::Schema.define(version: 20180227193547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_accounts_on_name"
  end

  create_table "contents", force: :cascade do |t|
    t.string "content_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "operations", force: :cascade do |t|
    t.string "op_controller"
    t.string "op_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["op_controller", "op_action"], name: "index_operations_on_op_controller_and_op_action"
  end

  create_table "permitteds", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "operation_id"
    t.string "type"
    t.index ["operation_id"], name: "index_permitteds_on_operation_id"
    t.index ["role_id"], name: "index_permitteds_on_role_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.string "relationship_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.integer "user_id"
    t.index ["account_id"], name: "index_relationships_on_account_id"
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "relationships", "accounts"
  add_foreign_key "relationships", "users"
end
