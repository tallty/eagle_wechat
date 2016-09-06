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

ActiveRecord::Schema.define(version: 20151217034635) do

  create_table "alarms", force: :cascade do |t|
    t.string   "title"
    t.string   "category"
    t.datetime "alarmed_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "rindex"
    t.string   "identifier"
    t.string   "content"
    t.text     "info"
    t.datetime "end_time"
    t.integer  "customer_id"
    t.integer  "user_id"
  end

  add_index "alarms", ["customer_id"], name: "index_alarms_on_customer_id"
  add_index "alarms", ["user_id"], name: "index_alarms_on_user_id"

  create_table "api_users", force: :cascade do |t|
    t.string   "appid"
    t.string   "company"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "api_users", ["customer_id"], name: "index_api_users_on_customer_id"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "addr"
    t.string   "explain"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "identifier"
  end

  add_index "customers", ["name"], name: "index_customers_on_name"

  create_table "disk_infos", force: :cascade do |t|
    t.string   "name"
    t.string   "full_name"
    t.integer  "disk_size"
    t.integer  "machine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "disk_infos", ["machine_id"], name: "index_disk_infos_on_machine_id"

  create_table "diymenus", force: :cascade do |t|
    t.integer  "public_account_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "key"
    t.string   "url"
    t.boolean  "is_show"
    t.integer  "sort"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "diymenus", ["key"], name: "index_diymenus_on_key"
  add_index "diymenus", ["parent_id"], name: "index_diymenus_on_parent_id"
  add_index "diymenus", ["public_account_id"], name: "index_diymenus_on_public_account_id"

  create_table "interface_reports", force: :cascade do |t|
    t.datetime "datetime"
    t.string   "identifier"
    t.string   "name"
    t.string   "first_times"
    t.string   "second_times"
    t.string   "third_times"
    t.integer  "first_count"
    t.integer  "second_count"
    t.integer  "third_count"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "sum_count"
  end

  add_index "interface_reports", ["datetime"], name: "index_interface_reports_on_datetime"
  add_index "interface_reports", ["identifier"], name: "index_interface_reports_on_identifier"
  add_index "interface_reports", ["name"], name: "index_interface_reports_on_name"

  create_table "interfaces", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
    t.string   "address"
  end

  create_table "interfaces_api_users", force: :cascade do |t|
    t.integer  "interface_id"
    t.integer  "api_user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "interfaces_api_users", ["api_user_id"], name: "index_interfaces_api_users_on_api_user_id"
  add_index "interfaces_api_users", ["interface_id"], name: "index_interfaces_api_users_on_interface_id"

  create_table "machine_details", force: :cascade do |t|
    t.string   "cpu_name"
    t.string   "mhz"
    t.integer  "cpu_real"
    t.integer  "cpu_total"
    t.string   "memory_swap_total"
    t.string   "memory_total"
    t.string   "network_external_address"
    t.string   "network_address"
    t.integer  "machine_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "machine_details", ["machine_id"], name: "index_machine_details_on_machine_id"

  create_table "machines", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.string   "explain"
    t.integer  "operating_status", default: 0
    t.integer  "customer_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "cpu_type"
  end

  add_index "machines", ["customer_id"], name: "index_machines_on_customer_id"
  add_index "machines", ["identifier"], name: "index_machines_on_identifier"

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "openid"
    t.string   "nick_name"
    t.string   "headimg"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "members", ["customer_id"], name: "index_members_on_customer_id"

  create_table "qy_apps", force: :cascade do |t|
    t.string "qy_token"
    t.string "encoding_aes_key"
    t.string "corp_id"
    t.string "qy_secret_key"
  end

  add_index "qy_apps", ["corp_id"], name: "index_qy_apps_on_corp_id"
  add_index "qy_apps", ["encoding_aes_key"], name: "index_qy_apps_on_encoding_aes_key"
  add_index "qy_apps", ["qy_secret_key"], name: "index_qy_apps_on_qy_secret_key"
  add_index "qy_apps", ["qy_token"], name: "index_qy_apps_on_qy_token"

  create_table "send_logs", force: :cascade do |t|
    t.integer  "alarm_id"
    t.string   "accept_user"
    t.string   "info"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sms_logs", force: :cascade do |t|
    t.string   "content"
    t.integer  "customer_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "warning_state"
    t.integer  "task_id"
  end

  add_index "sms_logs", ["customer_id"], name: "index_sms_logs_on_customer_id"
  add_index "sms_logs", ["task_id"], name: "index_sms_logs_on_task_id"

  create_table "task_logs", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "task_identifier"
    t.string   "exception"
    t.text     "file_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "task_name"
  end

  add_index "task_logs", ["start_time"], name: "index_task_logs_on_start_time"
  add_index "task_logs", ["task_identifier"], name: "index_task_logs_on_task_identifier"

  create_table "tasks", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.integer  "rate"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "customer_id"
    t.integer  "alarm_threshold"
  end

  create_table "total_interfaces", force: :cascade do |t|
    t.datetime "datetime"
    t.string   "identifier"
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "api_user_id"
  end

  add_index "total_interfaces", ["api_user_id"], name: "index_total_interfaces_on_api_user_id"
  add_index "total_interfaces", ["datetime"], name: "index_total_interfaces_on_datetime"
  add_index "total_interfaces", ["identifier"], name: "index_total_interfaces_on_identifier"
  add_index "total_interfaces", ["name"], name: "index_total_interfaces_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "phone"
    t.string   "status"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "open_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
