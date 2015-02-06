class ChangeDatatypePostIdOfTweet < ActiveRecord::Migration
  def change
    change_column :tweets, :post_id, :string
  end
end
