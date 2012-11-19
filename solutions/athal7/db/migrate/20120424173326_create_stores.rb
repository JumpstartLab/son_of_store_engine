class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :status, default: "pending"
      t.string :domain

      t.timestamps
    end
  end
end
