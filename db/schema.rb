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

ActiveRecord::Schema.define(:version => 20120425195448) do

  create_table "billing_methods", :force => true do |t|
    t.string   "credit_card_number"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
    t.string   "card_type"
    t.integer  "month"
    t.integer  "year"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "store_id"
  end

  add_index "categories", ["store_id"], :name => "index_categories_on_store_id"

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "billing_method_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "status",              :default => "pending"
    t.integer  "shipping_address_id"
    t.string   "action_time"
    t.integer  "store_id"
    t.string   "special_url"
  end

  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "product_categorizations", :force => true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "price"
    t.string   "photo_url"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "retired",     :default => false
    t.integer  "store_id"
  end

  add_index "products", ["store_id"], :name => "index_products_on_store_id"

  create_table "shipping_addresses", :force => true do |t|
    t.string   "street"
    t.string   "state"
    t.string   "zipcode"
    t.string   "city"
    t.string   "name"
    t.string   "email_address"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "status",      :default => "pending"
    t.string   "domain"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "enabled",     :default => false
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "email_address"
    t.string   "full_name"
    t.string   "display_name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.boolean  "admin",           :default => false
    t.boolean  "admin_view",      :default => false
  end

end
