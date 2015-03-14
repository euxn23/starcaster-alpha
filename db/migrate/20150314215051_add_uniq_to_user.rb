class AddUniqToUser < ActiveRecord::Migration
  def change
    change_column(:users, :tw_uid, :string, :unique => true)
  end
end
