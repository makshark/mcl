json.array!(@big_tournament_tours) do |big_tournament_tour|
  json.extract! big_tournament_tour, :id
  json.url big_tournament_tour_url(big_tournament_tour, format: :json)
end
