class AddTwitterPresetsToUser < ActiveRecord::Migration
  def change
    add_column :users, :preset_tl, :string
    add_column :users, :preset_fav, :string
  end
end
