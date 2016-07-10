class Fate < ActiveRecord::Base
  belongs_to :big_tournament_tour
  belongs_to :player

  def self.generate_big_tournament_tour_fate(big_tournament_tour_id)
    Fate.where(big_tournament_tour_id: big_tournament_tour_id).destroy_all
    big_tournament_tour = BigTournamentTour.where(id: big_tournament_tour_id).first
    players = TournamentPlayersTeam.where(big_tournament_tour_id: big_tournament_tour_id).order(:tournament_players_team_name_id).to_a
    # Генерируем дефолтный список из игр которые могут быть в big_tournament_tour_id
    1.upto(big_tournament_tour.tour_amount) do |tour|
      free_places = {}
      available_tables = (1..big_tournament_tour.table_amount).to_a
      available_tables.each do |table|
        free_places[table] = (1..10).to_a
      end
      # Узаем сколько всего в линии
      players.in_groups_of(2) do |players|
        available_tables = (1..big_tournament_tour.table_amount).to_a if available_tables.empty?
        random_first_team_table = available_tables.sample
        available_tables.delete(random_first_team_table)
        random_second_team_table = available_tables.sample
        available_tables.delete(random_second_team_table)

        first_player_place = free_places[random_first_team_table].sample
        free_places[random_first_team_table].delete(first_player_place)
        second_player_place = free_places[random_second_team_table].sample
        free_places[random_second_team_table].delete(second_player_place)

        Fate.create(big_tournament_tour_id: big_tournament_tour.id, player_id: players[0].player_id, tour: tour,
                    table: random_first_team_table, place: first_player_place )

        Fate.create(big_tournament_tour_id: big_tournament_tour.id, player_id: players[1].player_id, tour: tour,
                    table: random_second_team_table, place: second_player_place )
        available_tables.delete(random_first_team_table)  if free_places[random_first_team_table].empty?
        available_tables.delete(random_second_team_table) if free_places[random_second_team_table].empty?
      end
    end
      Fate.where(place: nil).destroy_all
  end
end
