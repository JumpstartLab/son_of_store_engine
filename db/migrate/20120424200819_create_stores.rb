class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :store_unique_id
      t.string :description
      t.string :status,             :default => 'pending'
      t.timestamps
    end
  end
end
