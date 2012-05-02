class AddIndexes < ActiveRecord::Migration
  def change
    add_index(:carts, :store_id)
    add_index(:carts, :user_id)
    add_index(:cart_items, [:product_id, :cart_id])
    add_index(:categories, :store_id)
    add_index(:orders, :store_id)
    add_index(:orders, :user_id)
    add_index(:order_items, [:product_id, :order_id])
    add_index(:products, :store_id)
    add_index(:privileges, :user_id)
    add_index(:privileges, :store_id)
  end
end
