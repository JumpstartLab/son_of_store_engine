class CreateStoreProductsTable < ActiveRecord::Migration
  def change
    create_table :store_products do |t|
      t.integer :product_id
      t.integer :store_id

      t.timestamps
    end
  end
end
