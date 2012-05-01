class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :status
      t.integer :address_id
      t.integer :store_id

      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :address_id
    add_index :orders, :store_id
  end
end
