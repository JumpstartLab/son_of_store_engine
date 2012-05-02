class AddUserIndexToOrder < ActiveRecord::Migration
  def change
    add_index :orders, [:store_id, :user_id]
  end
end
