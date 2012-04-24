class AddStoreIdToCart < ActiveRecord::Migration
  def change
    add_column :carts, :store_id, :integer
  end
end
