class AddStoreIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :store_id, :integer
  end
end
