class CreateVisitorUsers < ActiveRecord::Migration
  def change
    create_table :visitor_users do |t|
      t.string    :email
      t.string   :stripe_id
      t.timestamps
    end
  end
end
