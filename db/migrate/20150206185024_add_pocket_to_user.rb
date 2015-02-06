class AddPocketToUser < ActiveRecord::Migration
  def change
    add_column :users, :p_id, :string
    add_column :users, :p_key, :string
    add_column :users, :p_secret, :string
  end
end
