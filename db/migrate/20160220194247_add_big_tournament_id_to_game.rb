class AddBigTournamentIdToGame < ActiveRecord::Migration
  def change
    add_reference :games, :big_tournament_tour
  end
end
