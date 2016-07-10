class AddTournamentPlayersTeamNameToTournamentsPlayerTeam < ActiveRecord::Migration
  def change
    add_reference :tournament_players_teams, :tournament_players_team_name
  end
end
