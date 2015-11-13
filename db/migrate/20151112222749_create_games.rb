class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date
      t.integer :number
      t.integer :leading_id
      t.integer :victory
      t.integer :killed_first_id
      t.integer :best_player_table_id
      t.integer :best_player_leading_id

      t.timestamps null: false
    end

    add_index :games, :leading_id
    add_index :games, :killed_first_id
    add_index :games, :best_player_table_id
    add_index :games, :best_player_leading_id
  end
end
