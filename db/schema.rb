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

ActiveRecord::Schema.define(:version => 20120426025615) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "zipcode"
    t.integer  "user_id"
    t.string   "state"
    t.string   "country"
    t.string   "formatted_address"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "advanced_searches", :force => true do |t|
    t.integer  "status_id"
    t.integer  "order_total"
    t.string   "order_total_operator"
    t.date     "order_date"
    t.string   "order_date_operator"
    t.string   "email"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "active",     :default => 1
    t.integer  "sale_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "store_id"
  end

  add_index "categories", ["store_id", "id"], :name => "index_categories_on_store_id_and_id"

  create_table "category_products", :id => false, :force => true do |t|
    t.integer  "category_id", :null => false
    t.integer  "product_id",  :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "order_products", :force => true do |t|
    t.integer  "order_id",                      :null => false
    t.integer  "product_id",                    :null => false
    t.integer  "price_in_cents"
    t.integer  "quantity",       :default => 1
    t.integer  "percent_off",    :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status_id"
    t.string   "unique_url"
    t.integer  "is_cart",      :default => 1
    t.datetime "shipped_at"
    t.datetime "returned_at"
    t.datetime "cancelled_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "store_id"
  end

  add_index "orders", ["store_id", "id"], :name => "index_orders_on_store_id_and_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_ratings", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "active",     :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price_in_cents"
    t.integer  "active",              :default => 1
    t.datetime "inactive_date"
    t.integer  "sale_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "store_id"
  end

  add_index "products", ["store_id", "id"], :name => "index_products_on_store_id_and_id"

  create_table "sales", :force => true do |t|
    t.integer  "percent_off"
    t.datetime "end_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "store_id"
  end

  add_index "sales", ["store_id", "id"], :name => "index_sales_on_store_id_and_id"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "store_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.integer  "permission", :default => 9
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.integer  "active",      :default => 1
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "enabled",     :default => false
    t.text     "description"
    t.string   "status",      :default => "pending"
    t.string   "url"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "email"
    t.string   "display_name"
    t.integer  "permission",       :default => 1
    t.integer  "active",           :default => 1
    t.string   "stripe_id"
    t.string   "phone_number"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "guest",            :default => false
  end

end
