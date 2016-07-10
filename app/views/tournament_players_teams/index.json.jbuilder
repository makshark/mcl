json.array!(@tournament_players_teams) do |tournament_players_team|
  json.extract! tournament_players_team, :id
  json.url tournament_players_team_url(tournament_players_team, format: :json)
end
