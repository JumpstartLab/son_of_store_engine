class ChangeCartItemsDefaultTo1 < ActiveRecord::Migration
  def up
    change_column_default(:cart_items, :quantity, 1)
  end

  def down
  change_column_default(:cart_items, :quantity, nil)
  end
end
