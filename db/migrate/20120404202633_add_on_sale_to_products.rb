class AddOnSaleToProducts < ActiveRecord::Migration
  def change
    add_column :products, :on_sale, :boolean, :default => true
  end
end
