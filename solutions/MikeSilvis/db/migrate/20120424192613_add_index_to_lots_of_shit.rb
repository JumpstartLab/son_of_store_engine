class AddIndexToLotsOfShit < ActiveRecord::Migration
  def change
    add_index :categories, [:store_id, :id]
    add_index :orders, [:store_id, :id]
    add_index :products, [:store_id, :id]
    add_index :sales, [:store_id, :id]
  end
end
