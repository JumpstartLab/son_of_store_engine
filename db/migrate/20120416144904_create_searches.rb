class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :products
      t.string :orders

      t.timestamps
    end
  end
end