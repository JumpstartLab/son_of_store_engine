class DropStoreProductsTable < ActiveRecord::Migration
  def change
    drop_table :store_products
  end
end
