class AddIndexToLotsOfShit < ActiveRecord::Migration
  def change
    add_index, :addresses, :user_id
  end
end
