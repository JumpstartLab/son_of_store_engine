class AddIndexToLotsOfShit < ActiveRecord::Migration
  def change
    add_index, :addresses, [:store_id, :user_id]
  end
end
