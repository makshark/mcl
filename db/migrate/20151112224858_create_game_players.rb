class CreateGamePlayers < ActiveRecord::Migration
  def change
    create_table :game_players do |t|
      t.references :game
      t.references :player
      t.integer :role #ENUM
      t.integer :remark
      t.integer :table_number #Номер за столом
      t.decimal :points

      t.timestamps null: false
    end
  end
end
