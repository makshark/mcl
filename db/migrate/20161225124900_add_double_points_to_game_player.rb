class AddDoublePointsToGamePlayer < ActiveRecord::Migration
  def change
    add_column :games, :double_points, :boolean, default: false
  end
end
