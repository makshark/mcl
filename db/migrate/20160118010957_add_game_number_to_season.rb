class AddGameNumberToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :game_number, :integer, default: 1
  end
end
