class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer :tweet_id
      t.string :url

      t.timestamps null: false
    end
  end
end
