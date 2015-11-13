class CreateBestGameMoves < ActiveRecord::Migration
  def change
    create_table :best_game_moves do |t|
      t.references :game
      t.references :player
      t.timestamps null: false
    end
  end
end
