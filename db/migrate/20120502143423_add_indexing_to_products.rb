class AddIndexingToProducts < ActiveRecord::Migration
  def change
    add_index :products, [:updated_at, :store_id, :active]
    add_index :products, [:updated_at]
    add_index :products, [:active]
  end
end
