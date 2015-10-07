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

ActiveRecord::Schema.define(version: 20151006080719) do

  create_table "customers", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "addr",         limit: 255
    t.string   "explain",      limit: 255
    t.string   "abbreviation", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "customers", ["name"], name: "index_customers_on_name", using: :btree

  create_table "machine_details", force: :cascade do |t|
    t.string   "cpu_name",                 limit: 255
    t.string   "mhz",                      limit: 255
    t.integer  "cpu_real",                 limit: 4
    t.integer  "cpu_total",                limit: 4
    t.string   "memory_swap_total",        limit: 255
    t.string   "memory_total",             limit: 255
    t.string   "network_external_address", limit: 255
    t.string   "network_address",          limit: 255
    t.integer  "machine_id",               limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "machine_details", ["machine_id"], name: "index_machine_details_on_machine_id", using: :btree

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
  add_index "machines", ["identifier"], name: "index_machines_on_identifier", using: :btree

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

end
