class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.timestamps
    end
  end
end
