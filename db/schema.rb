ActiveRecord::Schema.define(version: 20190722020456) do

  create_table "members", force: :cascade do |t|
    t.integer "sub_forum_id"
    t.integer "user_id"
    t.integer "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_forum_id", "user_id"], name: "index_members_on_sub_forum_id_and_user_id", unique: true
    t.index ["sub_forum_id"], name: "index_members_on_sub_forum_id"
    t.index ["user_id"], name: "index_members_on_user_id"
    t.index ["user_type"], name: "index_members_on_user_type"
  end

  create_table "sub_forums", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sub_forums_on_name", unique: true
    t.index ["user_id"], name: "index_sub_forums_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
