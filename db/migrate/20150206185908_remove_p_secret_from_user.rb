class RemovePSecretFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :p_secret, :string
  end
end
