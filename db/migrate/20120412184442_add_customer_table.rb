class AddCustomerTable < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :stripe_token
      t.integer :user_id
      t.string :ship_address
      t.string :ship_address2
      t.string :ship_state
      t.string :ship_zipcode
      t.string :ship_city
      t.timestamps
    end
  end
end
