class AddMiniTournamentReferenceToGame < ActiveRecord::Migration
  def change
    add_reference :games, :mini_tournament, index: true
  end
end
