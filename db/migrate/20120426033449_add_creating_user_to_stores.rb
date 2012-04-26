class AddCreatingUserToStores < ActiveRecord::Migration
  def change
    add_column :stores, :creating_user_id, :integer
  end
end
