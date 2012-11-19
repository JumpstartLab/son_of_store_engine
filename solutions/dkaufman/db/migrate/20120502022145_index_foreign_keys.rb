class IndexForeignKeys < ActiveRecord::Migration
  def change
    add_index :billing_methods, :user_id
    add_index :line_items, :order_id
    add_index :line_items, :product_id
    add_index :orders, :user_id
    add_index :orders, :billing_method_id
    add_index :orders, :shipping_address_id
    add_index :product_categorizations, :product_id
    add_index :product_categorizations, :category_id
    add_index :shipping_addresses, :user_id
    add_index :stores, :creating_user_id
    add_index :store_permissions, :user_id
    add_index :store_permissions, :store_id
  end
end
