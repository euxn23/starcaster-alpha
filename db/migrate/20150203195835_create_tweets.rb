class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :post_id
      t.string :text
      t.string :user_name
      t.string :user_sid
      t.integer :user_uid
      t.string :user_image

      t.timestamps null: false
    end
  end
end
