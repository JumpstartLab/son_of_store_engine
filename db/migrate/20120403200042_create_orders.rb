class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer		:user_id
      t.decimal   :total_price, :precision => 12, :scale => 2
      t.integer   :address_id
      t.timestamps
    end
  end
end
