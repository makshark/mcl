class ChangePointsDataTypeColumn < ActiveRecord::Migration
  def change
    change_column :game_players, :points, :decimal, scale: 2, precision: 5
  end
end
