class CreateTournamentPlayersTeamNames < ActiveRecord::Migration
  def change
    create_table :tournament_players_team_names do |t|
      t.string :name, default: ''
      
      t.timestamps null: false
    end
  end
end
