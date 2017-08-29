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

ActiveRecord::Schema.define(version: 20170829184340) do

  create_table "application_details", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "purpose",     limit: 255
    t.text     "the_text",    limit: 65535
    t.string   "description", limit: 255
  end

  create_table "auth_affiliations", force: :cascade do |t|
    t.string   "affiliation_code",  limit: 255
    t.string   "affiliation_title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patron_exceptions", force: :cascade do |t|
    t.string   "username",   limit: 255
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patron_statuses", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "web_text",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patrons", force: :cascade do |t|
    t.string   "firstname",         limit: 255
    t.string   "lastname",          limit: 255
    t.string   "email",             limit: 255
    t.boolean  "submitted_request"
    t.datetime "submitted_at"
    t.date     "dob"
    t.string   "barcode",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",          limit: 255,   default: "", null: false
    t.string   "mobile_phone",      limit: 255
    t.string   "crypted_password",  limit: 255
    t.string   "password_salt",     limit: 255
    t.string   "persistence_token", limit: 255,                null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "expiration_date"
    t.datetime "last_login_at"
    t.text     "user_attributes",   limit: 65535
    t.datetime "refreshed_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname",         limit: 255
    t.string   "lastname",          limit: 255
    t.string   "email",             limit: 255
    t.boolean  "submitted_request"
    t.datetime "submitted_at"
    t.string   "barcode",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",          limit: 255,   default: "", null: false
    t.datetime "expiration_date"
    t.datetime "refreshed_at"
    t.string   "provider",          limit: 255,   default: "", null: false
    t.string   "institution_code",  limit: 255
    t.string   "aleph_id",          limit: 255
    t.boolean  "admin"
    t.string   "patron_status",     limit: 255
    t.boolean  "override_access"
    t.string   "school",            limit: 255
    t.string   "department",        limit: 255
    t.text     "address",           limit: 65535
    t.text     "marli_renewal",     limit: 65535
    t.text     "affiliation_text",  limit: 65535
  end

end
