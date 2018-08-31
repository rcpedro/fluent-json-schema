ActiveRecord::Schema.define do
  self.verbose = false
  
  create_table "universities", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "description"
    t.string "created_by", null: false
    t.string "updated_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_universities_on_code"
    t.index ["name"], name: "index_universities_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "username", null: false
    t.string "contact_no"
    t.boolean "super", default: false, null: false
    t.integer "status", default: 0, null: false
    t.string "created_by", null: false
    t.string "updated_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["status"], name: "index_users_on_status"
    t.index ["super"], name: "index_users_on_super"
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "partner_id", null: false
    t.bigint "user_id", null: false
    t.bigint "course_id"
    t.string "type", null: false
    t.integer "status", default: 0, null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.string "created_by", null: false
    t.string "updated_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_members_on_course_id"
    t.index ["partner_id"], name: "index_members_on_partner_id"
    t.index ["status"], name: "index_members_on_status"
    t.index ["type"], name: "index_members_on_type"
    t.index ["user_id"], name: "index_members_on_user_id"
  end
end