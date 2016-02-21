class AddAdditionalBestPlayersIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :best_player_leading1_id, :integer
    add_column :games, :best_player_leading2_id, :integer
  end
end
