class CreateTournamentPlayersTeams < ActiveRecord::Migration
  def change
    create_table :tournament_players_teams do |t|
      t.references :big_tournament_tour
      t.references :player
      t.timestamps null: false
    end
  end
end
