class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :path
      t.string :status, :default => "pending"
      t.string :description
      
      t.timestamps
    end

    add_index :stores, :path
  end
end
