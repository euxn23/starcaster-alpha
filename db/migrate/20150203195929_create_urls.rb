class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.integer :tweet_id
      t.string :url

      t.timestamps null: false
    end
  end
end
