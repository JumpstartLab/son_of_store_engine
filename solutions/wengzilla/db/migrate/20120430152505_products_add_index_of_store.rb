class ProductsAddIndexOfStore < ActiveRecord::Migration
  def change
    add_index :product_categories, :category_id
    add_index :product_categories, :product_id
    add_index :cart_products, :cart_id
    drop_table :discounts
    add_index :order_products, :order_id
    add_index :order_products, :product_id
    add_index :order_statuses, :order_id
    add_index :roles, :user_id
    drop_table :store_users
    add_index :users, :email
  end
end
