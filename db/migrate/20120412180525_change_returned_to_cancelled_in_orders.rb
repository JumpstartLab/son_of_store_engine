class ChangeReturnedToCancelledInOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :returned, :date
    add_column :orders, :cancelled, :date
  end

  def down
    add_column :orders, :returned, :date
    remove_column :orders, :cancelled, :date
  end
end
