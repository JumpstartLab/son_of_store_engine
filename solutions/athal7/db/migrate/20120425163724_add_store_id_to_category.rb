class AddStoreIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :store_id, :integer
    add_index :categories, :store_id
  end
end
