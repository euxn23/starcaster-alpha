class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :tw_name
      t.string :tw_sid
      t.integer :tw_uid
      t.string :tw_key
      t.string :tw_secret
      t.string :provider

      t.timestamps null: false
    end
  end
end
