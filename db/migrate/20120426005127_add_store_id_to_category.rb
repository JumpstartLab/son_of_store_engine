class AddStoreIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :store_id, :integer
  end
end
