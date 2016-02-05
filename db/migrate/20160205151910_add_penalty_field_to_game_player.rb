class AddPenaltyFieldToGamePlayer < ActiveRecord::Migration
  def change
    add_column :game_players, :penalty_amount, :integer, default: 0
  end
end
