class ChangeColumnTypeInGamePlayer < ActiveRecord::Migration
  def change
    change_column :game_players, :remark, :integer, default: 0
  end
end
