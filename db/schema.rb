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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20151001031803) do

  create_table "cpus", force: :cascade do |t|
    t.string   "model_info", limit: 255
    t.string   "mhz",        limit: 255
    t.string   "cache_size", limit: 255
    t.integer  "machine_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "cpus", ["machine_id"], name: "index_cpus_on_machine_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "addr",         limit: 255
    t.string   "explain",      limit: 255
    t.string   "abbreviation", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "customers", ["name"], name: "index_customers_on_name", using: :btree

  create_table "machines", force: :cascade do |t|
    t.string   "identifier",       limit: 255
    t.string   "name",             limit: 255
    t.string   "explain",          limit: 255
    t.integer  "operating_status", limit: 4,   default: 0
    t.integer  "customer_id",      limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "machines", ["customer_id"], name: "index_machines_on_customer_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "phone",       limit: 255
    t.string   "email",       limit: 255
    t.string   "openid",      limit: 255
    t.string   "nick_name",   limit: 255
    t.string   "headimg",     limit: 255
    t.integer  "customer_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "members", ["customer_id"], name: "index_members_on_customer_id", using: :btree

  create_table "memory_infos", force: :cascade do |t|
    t.integer  "swap_total", limit: 4
    t.integer  "total",      limit: 4
    t.integer  "machine_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "memory_infos", ["machine_id"], name: "index_memory_infos_on_machine_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "name",                   limit: 255
    t.string   "phone",                  limit: 255
    t.string   "status",                 limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
=======
ActiveRecord::Schema.define(version: 0) do
>>>>>>> 11785b377754f4aad9f5c271d29f25828710a448

end
