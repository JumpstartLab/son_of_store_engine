class CreateVisitorUsers < ActiveRecord::Migration
  def change
    create_table :visitor_users do |t|
      t.string    :email
      t.timestamps
    end
  end
end
