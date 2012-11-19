class AddSortedIndexToProducts < ActiveRecord::Migration
  def change
    add_index "products", ["store_id", "active", "updated_at"]
  end
end
