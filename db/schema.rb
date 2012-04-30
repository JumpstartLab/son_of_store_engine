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

ActiveRecord::Schema.define(:version => 20120430152505) do

  create_table "cart_products", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "quantity",   :default => 1
  end

  add_index "cart_products", ["cart_id"], :name => "index_cart_products_on_cart_id"

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "store_id"
  end

  add_index "carts", ["store_id", "id"], :name => "index_carts_on_store_id_and_id"
  add_index "carts", ["store_id"], :name => "index_carts_on_store_id"
  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "store_id"
  end

  add_index "categories", ["store_id", "id"], :name => "index_categories_on_store_id_and_id"
  add_index "categories", ["store_id"], :name => "index_categories_on_store_id"

  create_table "credit_cards", :force => true do |t|
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "user_id"
    t.string   "credit_card_type"
    t.string   "last_four"
    t.string   "exp_month"
    t.string   "exp_year"
    t.string   "stripe_customer_token"
    t.boolean  "default_card",          :default => false
    t.integer  "store_id"
  end

  add_index "credit_cards", ["store_id", "id"], :name => "index_credit_cards_on_store_id_and_id"
  add_index "credit_cards", ["store_id"], :name => "index_credit_cards_on_store_id"
  add_index "credit_cards", ["user_id"], :name => "index_credit_cards_on_user_id"

  create_table "order_products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "price_cents"
    t.integer  "quantity"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "order_products", ["order_id"], :name => "index_order_products_on_order_id"
  add_index "order_products", ["product_id"], :name => "index_order_products_on_product_id"

  create_table "order_statuses", :force => true do |t|
    t.string   "status",     :default => "pending"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "order_id"
  end

  add_index "order_statuses", ["order_id"], :name => "index_order_statuses_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "credit_card_id"
    t.integer  "store_id"
    t.integer  "shipping_detail_id"
  end

  add_index "orders", ["store_id", "id"], :name => "index_orders_on_store_id_and_id"
  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "product_categories", :force => true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "product_categories", ["category_id"], :name => "index_product_categories_on_category_id"
  add_index "product_categories", ["product_id"], :name => "index_product_categories_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "price_cents"
    t.string   "photo"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "retired",     :default => false
    t.integer  "store_id"
  end

  add_index "products", ["store_id", "id"], :name => "index_products_on_store_id_and_id"
  add_index "products", ["store_id"], :name => "index_products_on_store_id"

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["user_id"], :name => "index_roles_on_user_id"

  create_table "shipping_details", :force => true do |t|
    t.string   "ship_to_name"
    t.string   "ship_to_address_1"
    t.string   "ship_to_address_2"
    t.string   "ship_to_city"
    t.string   "ship_to_state"
    t.string   "ship_to_country"
    t.string   "ship_to_zip"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "default_shipping_address", :default => false
    t.integer  "user_id"
    t.integer  "store_id"
  end

  add_index "shipping_details", ["store_id", "id"], :name => "index_shipping_details_on_store_id_and_id"
  add_index "shipping_details", ["store_id"], :name => "index_shipping_details_on_store_id"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "status",      :default => "pending"
    t.string   "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "stores", ["slug"], :name => "index_stores_on_path"

  create_table "users", :force => true do |t|
    t.string   "email",                        :null => false
    t.string   "name",                         :null => false
    t.string   "display_name"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "type"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
