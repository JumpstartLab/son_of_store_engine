class AddMoreIndexes < ActiveRecord::Migration
  def change
    add_index :products, [:store_id, :active]
  end
end
