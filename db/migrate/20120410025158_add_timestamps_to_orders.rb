class AddTimestampsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipped, :date
    add_column :orders, :cancelled, :date
  end
end
