class AddUniqueUrlToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :unique_url, :string
  end
end
