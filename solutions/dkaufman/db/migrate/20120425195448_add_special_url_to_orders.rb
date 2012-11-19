class AddSpecialUrlToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :special_url, :string
  end
end
