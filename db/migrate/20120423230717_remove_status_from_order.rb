class RemoveStatusFromOrder < ActiveRecord::Migration
  def change
    drop_table :statuses
    add_column :orders, :status, :string
  end
end
