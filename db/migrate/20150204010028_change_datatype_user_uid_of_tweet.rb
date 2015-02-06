class ChangeDatatypeUserUidOfTweet < ActiveRecord::Migration
  def change
    change_column :tweets, :user_uid, :string
  end
end
