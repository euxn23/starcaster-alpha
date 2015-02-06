class AddHatenaToUser < ActiveRecord::Migration
  def change
    add_column :users, :h_id, :string
    add_column :users, :h_key, :string
    add_column :users, :h_secret, :string
  end
end
