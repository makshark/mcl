class TournamentPlayersTeam < ActiveRecord::Base
  belongs_to :tournament_players_team_name
  belongs_to :player
  belongs_to :big_tournament_tour
end


# all_names = TournamentPlayersTeamName.all.to_a
# Player.all.to_a.in_groups_of(2) do |players|
#   TournamentPlayersTeam.create(big_tournament_tour_id: 7, player_id: players[0].id, tournament_players_team_name_id: all_names.first.id)
#   TournamentPlayersTeam.create(big_tournament_tour_id: 7, player_id: players[1].id, tournament_players_team_name_id: all_names.first.id)
#   all_names.delete(all_names.first)
# end
# TournamentPlayersTeamName.destroy_all
# 20.times {|x| TournamentPlayersTeamName.create(name: "Team#{x}")}