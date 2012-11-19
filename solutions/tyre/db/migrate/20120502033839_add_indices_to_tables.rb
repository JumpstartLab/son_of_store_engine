class AddIndicesToTables < ActiveRecord::Migration
  def change
    add_index "cart_products", ["cart_id"], name:"index_cart_products_on_cart_id"
    add_index "cart_products", ["product_id"], name: "index_cart_products_on_product_id" 
    add_index "categories", ["store_id"], name: "index_categories_on_store_id"
    add_index "discounts", ["product_id"], name: "index_discounts_on_product_id"
    add_index "discounts", ["category_id"], name: "index_discounts_on_category_id"
    add_index "order_products", ["order_id"], name: "index_order_products_on_order_id"
    add_index "order_products", ["product_id"], name: "index_order_products_on_product_id"
    add_index "order_shipping_details", ["order_id"], name: "index_order_shipping_details_on_order_id"
    add_index "order_shipping_details", ["shipping_detail_id"], name: "index_order_shipping_details_on_shipping_detail_id"
    add_index "order_statuses", ["order_id"], name: "index_order_statuses_on_order_id"
    add_index "orders", ["user_id"], name: "index_orders_on_user_id"
    add_index "orders", ["credit_card_id"], name: "index_orders_on_credit_card_id"
    add_index "product_categories", ["product_id"], name: "index_product_categories_on_product_id"
    add_index "product_categories", ["category_id"], name: "index_product_categories_on_category_id"
    add_index "products", ["store_id"], name: "index_products_on_store_id"
    add_index "shipping_details", ["user_id"], name: "index_shipping_details_on_user_id"
    add_index "store_admins", ["store_id"], name: "index_store_admins_on_store_id"
    add_index "store_admins", ["user_id"], name: "index_store_admins_on_user_id"
  end
end
