class ProductsAddIndex < ActiveRecord::Migration
  def change
    add_index :products, [ :store_id, :id, :retired ]
    add_index :products, [ :store_id, :retired ]
  end
end
