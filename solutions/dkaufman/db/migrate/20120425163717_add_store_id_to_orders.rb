class AddStoreIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :store_id, :integer
    add_index :orders, :store_id
  end
end
