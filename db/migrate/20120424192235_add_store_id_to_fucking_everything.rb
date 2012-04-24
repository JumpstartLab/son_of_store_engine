class AddStoreIdToFuckingEverything < ActiveRecord::Migration
  def change
    add_column :categories, :store_id, :integer
    add_column :orders, :store_id, :integer
    add_column :products, :store_id, :integer
    add_column :sales, :store_id, :integer
  end
end
