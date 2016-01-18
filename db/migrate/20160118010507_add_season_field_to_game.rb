class AddSeasonFieldToGame < ActiveRecord::Migration
  def change
    add_reference :games, :season, index: true
  end
end
