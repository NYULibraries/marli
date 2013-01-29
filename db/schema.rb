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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130117000251) do

  create_table "application_details", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "purpose"
    t.text     "the_text"
    t.string   "description"
  end

  create_table "patron_statuses", :force => true do |t|
    t.string   "code"
    t.string   "web_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.boolean  "submitted_request"
    t.datetime "submitted_at"
    t.date     "dob"
    t.string   "barcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",          :default => "", :null => false
    t.string   "mobile_phone"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                 :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "expiration_date"
    t.datetime "last_login_at"
    t.text     "user_attributes"
    t.datetime "refreshed_at"
  end

end
