json.array!(@mini_tournaments) do |mini_tournament|
  json.extract! mini_tournament, :id
  json.url mini_tournament_url(mini_tournament, format: :json)
end
