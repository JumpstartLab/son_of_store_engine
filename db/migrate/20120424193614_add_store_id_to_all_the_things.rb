class AddStoreIdToAllTheThings < ActiveRecord::Migration
  def change
    add_column :carts,            :store_id, :integer
    add_column :categories,       :store_id, :integer
    add_column :credit_cards,     :store_id, :integer
    add_column :orders,           :store_id, :integer
    add_column :products,         :store_id, :integer
    add_column :shipping_details, :store_id, :integer

    to_index = [:store_id, [:store_id, :id]]
    to_index.each do |cols|
      add_index :carts,            cols
      add_index :categories,       cols
      add_index :credit_cards,     cols
      add_index :orders,           cols
      add_index :products,         cols
      add_index :shipping_details, cols
    end
  end
end
