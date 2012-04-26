class OrderAddShippingDetailIdColumn < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_detail_id, :integer
    drop_table :order_shipping_details
  end
end
