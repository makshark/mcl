class MafiaStarsController < ApplicationController
  # TODO: обязательно удалить этот контоллер и предлать все в нормальую структуру

  def index
    @tours = BigTournamentTour.all
  end

  def mafia_stars_results
    @tour = BigTournamentTour.where(id: params[:id]).first
    # Если нету игроков, выводить сообщение тур еще не сыгран
    @list_of_players = @tour.list_of_players.split(' ')

    @result_array = []
    object = {}
    players_points_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = ?', @tour.id).group(:player_id).sum(:points)
    players_points_count.each do |player|
      nick = Player.where(id: player[0]).first
      object[:penalty_amount] = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?)', @tour.id, player[0]).sum(:penalty_amount)
      # TODO: не забыть сложную карту
      # Сколько раз был лучшим
      best_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?) AND (games.best_player_leading_id = (?) OR games.best_player_leading1_id = (?) OR games.best_player_leading2_id = (?))', @tour.id, player[0], player[0], player[0], player[0]).count
      # Сколько раз победил
      # TODO: возможно переделать если придумаю лучшее решение
      victories = 0
      best_moves = 0
      game_list = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?)', @tour.id, player[0])
      game_list.each do |game_player|
        game_player.win? ? victories += 1 : victories += 0
        best_moves += 1 if game_player.best_move > 0
      end
      ######
      # Сыграл Шерифом (3 - enum для шерифа)
      sheriff_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?) AND game_players.role = 3', @tour.id, player[0]).count
      ######
      # Сыграл мафией (дон - 2)
      don_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?) AND game_players.role = 2', @tour.id, player[0]).count
      ######
      # Сыграл доном (мафия - 0)
      mafia_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?) AND game_players.role = 0', @tour.id, player[0]).count
      ######
      # Убит в 1 ночь
      killed_first_night = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?) AND games.killed_first_id = ?', @tour.id, player[0], player[0]).count
      #######
      rating = player[1]
      # object[:game_count] = game_count
      object[:nick] = nick.try(:nick)
      object[:rating] = rating
      object[:best_count] = best_count
      object[:victories] = victories
      object[:sheriff_count] = sheriff_count
      object[:don_count] = don_count
      object[:mafia_count] = mafia_count
      object[:killed_first_night] = killed_first_night
      object[:best_moves] = best_moves

      # Роздел подсчета сложной карты
      # TODO: переписать в простой запрос, т.к. нужно только количество игр
      game_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?)', @tour.id, player[0]).count

      games_city_victories = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND games.victory = 0', @tour.id).count
      games_mafia_victories = game_count - games_city_victories
      # узнаем сложную карту
      if (games_city_victories - games_mafia_victories == 0) || games_city_victories == 0 || games_mafia_victories == 0
         @hard_card = 'отсутствует'
      else
        if games_city_victories > games_mafia_victories
          @additional_coefficient = (games_city_victories - games_mafia_victories).to_f / 2.0 * 0.1
          @hard_card = 'за мафию'
          # Получаем колличество игр выигранных игроком за мафию
          player_win_mafia = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND games.victory = 1 AND (game_players.role = 0 OR game_players.role = 2)', @tour.id).count
          object[:rating] += @additional_coefficient * player_win_mafia
        else
          @additional_coefficient = (games_mafia_victories - games_city_victories).to_f / 2.0 * 0.1
          @hard_card = 'за мирных'
          # Получаем колличество игр выигранных игроком за мирных
          player_win_citizen = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND games.victory = 1 AND (game_players.role = 1 OR game_players.role = 3)', @tour.id).count
          object[:rating] += @additional_coefficient * player_win_citizen
        end

      end
      ###############################
      @result_array << object
      object = {}
    end
    @result_array = @result_array.sort_by { |hsh| hsh[:rating] }.reverse!
    @games = Game.where(big_tournament_tour_id: params[:id]).order(:created_at)
  end


end
