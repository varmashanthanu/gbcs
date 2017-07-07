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

ActiveRecord::Schema.define(version: 20170626084328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "addr"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["addr"], name: "index_addresses_on_addr", using: :btree
  end

  create_table "comp_skills", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "skill_id"
    t.integer  "level"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["competition_id"], name: "index_comp_skills_on_competition_id", using: :btree
    t.index ["skill_id"], name: "index_comp_skills_on_skill_id", using: :btree
  end

  create_table "comp_teams", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.datetime "expiry"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["competition_id"], name: "index_comp_teams_on_competition_id", using: :btree
    t.index ["team_id"], name: "index_comp_teams_on_team_id", using: :btree
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "start"
    t.integer  "duration"
    t.string   "description"
    t.string   "prize"
    t.string   "host"
    t.integer  "creator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "comp_type"
    t.index ["name"], name: "index_competitions_on_name", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_invites_on_team_id", using: :btree
    t.index ["user_id"], name: "index_invites_on_user_id", using: :btree
  end

  create_table "master_passes", force: :cascade do |t|
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_members_on_team_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_skills_on_category", using: :btree
    t.index ["name"], name: "index_skills_on_name", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "avatar"
    t.integer  "lead_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", using: :btree
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
    t.index ["user_id"], name: "index_user_skills_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "fname"
    t.string   "lname"
    t.string   "avatar"
    t.string   "program"
    t.datetime "graduation"
    t.bigint   "telno"
    t.boolean  "admin"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "score"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["fname"], name: "index_users_on_fname", using: :btree
    t.index ["lname"], name: "index_users_on_lname", using: :btree
    t.index ["program"], name: "index_users_on_program", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["score"], name: "index_users_on_score", using: :btree
  end

  create_table "yes_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.string   "match"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_id"], name: "index_yes_lists_on_target_id", using: :btree
    t.index ["user_id"], name: "index_yes_lists_on_user_id", using: :btree
  end

  add_foreign_key "comp_skills", "competitions"
  add_foreign_key "comp_skills", "skills"
  add_foreign_key "comp_teams", "competitions"
  add_foreign_key "comp_teams", "teams"
  add_foreign_key "invites", "teams"
  add_foreign_key "invites", "users"
  add_foreign_key "members", "teams"
  add_foreign_key "members", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
