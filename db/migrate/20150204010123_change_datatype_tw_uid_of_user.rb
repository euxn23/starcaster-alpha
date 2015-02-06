class ChangeDatatypeTwUidOfUser < ActiveRecord::Migration
  def change
    change_column :users, :tw_uid, :string
  end
end
