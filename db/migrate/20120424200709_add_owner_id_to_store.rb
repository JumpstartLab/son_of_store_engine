class AddOwnerIdToStore < ActiveRecord::Migration
  def change
    add_column :stores, :owner_id, :integer
  end
end
