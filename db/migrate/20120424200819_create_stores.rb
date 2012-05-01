class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.string :status,             :default => 'pending'
      t.string :css
      t.timestamps
    end
  end
end
