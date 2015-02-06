class AddQiitaToUser < ActiveRecord::Migration
  def change
    add_column :users, :q_id, :string
    add_column :users, :q_key, :string
    add_column :users, :q_secret, :string
  end
end
