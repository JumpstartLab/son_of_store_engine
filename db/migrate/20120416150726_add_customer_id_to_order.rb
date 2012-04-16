class AddCustomerIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :customer_id, :integer
    remove_column :orders, :user_id
  end
end
