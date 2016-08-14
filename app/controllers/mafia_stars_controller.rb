class MafiaStarsController < ApplicationController
  # TODO: обязательно удалить этот контоллер и предлать все в нормальую структуру

  def index
    # List of all big tournaments tours
    @tours = BigTournamentTour.all.order(:created_at)
  end

  def mafia_stars_results
    # TODO: просто нереальный хардкод
    # params[:id] ||= 7
    @tour = BigTournamentTour.where(id: params[:id]).first
    # Если нету игроков, выводить сообщение тур еще не сыгран
    @list_of_players = @tour.try(:list_of_players)
    @list_of_players = @list_of_players.split(' ') if @list_of_players

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
      # Сыграл мирным (мирный - 1)
      citizen_count = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND game_players.player_id = (?) AND game_players.role = 1', @tour.id, player[0]).count
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
      object[:citizen_count] = citizen_count
      object[:killed_first_night] = killed_first_night
      object[:best_moves] = best_moves
      object[:player_id] = nick.try(:id)

      # Роздел подсчета сложной карты
      game_count = Game.where(big_tournament_tour_id: @tour.id).count
      games_city_victories = Game.where(big_tournament_tour_id: @tour.id, victory: 'city').count
      games_mafia_victories = game_count - games_city_victories
      # узнаем сложную карту
      if (games_city_victories - games_mafia_victories == 0) || games_city_victories == 0 || games_mafia_victories == 0
        @hard_card = 'отсутствует'
        object[:rating] += object[:penalty_amount] * (-0.5)
      else #TODO: коеф считается каждый раз в цикле - это бредятина
        if games_city_victories > games_mafia_victories
          @additional_coefficient = (games_city_victories - games_mafia_victories).to_f / 2.0 * 0.1
          @hard_card = 'за мафию'
          # Получаем колличество игр выигранных игроком за мафию
          player_win_mafia = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND games.victory = 1 AND (game_players.role = 0 OR game_players.role = 2) AND game_players.player_id = (?)', @tour.id, player[0]).count
          # Fix для другой формулы пересчета рейтинга в зависимости от сложной карты
          if @tour.id >= 9
            object[:rating] += (@additional_coefficient * 2 - 2) * player_win_mafia
          else
            object[:rating] += @additional_coefficient * player_win_mafia + (object[:penalty_amount] * (-0.5))
          end
        else
          @additional_coefficient = (games_mafia_victories - games_city_victories).to_f / 2.0 * 0.1
          @hard_card = 'за мирных'
          # Получаем колличество игр выигранных игроком за мирных
          player_win_citizen = GamePlayer.joins(:game).where('games.big_tournament_tour_id = (?) AND games.victory = 0 AND (game_players.role = 1 OR game_players.role = 3) AND game_players.player_id = (?)', @tour.id, player[0]).count
          if @tour.id >= 9
            object[:rating] += (@additional_coefficient * 2 - 2) * player_win_citizen
          else
            object[:rating] += @additional_coefficient * player_win_citizen + (object[:penalty_amount] * (-0.5))
          end
        end
      end
      ###############################
      @result_array << object
      object = {}
    end
    @result_array = @result_array.sort_by { |hsh| hsh[:rating] }.reverse!
    @games = Game.where(big_tournament_tour_id: params[:id]).order(:created_at)
    # TODO: разобраться, почему не работает, когда обращаюь через mafia, city (в поле victory)
    @total_victory_citizen = Game.where(big_tournament_tour_id: params[:id], victory: 0).count
    @total_victory_mafia = Game.where(big_tournament_tour_id: params[:id], victory: 1).count

    @final_team = []
    if @tour.big_tournament.mode == 'double'
      # Роздел подсчета командноо рейтинга, если таков имеется
      # Нужно как-то сгруппирвоать ко командам
      @team_result_array = @result_array
      @team_result_array.each do |player|
        team = TournamentPlayersTeam.where(big_tournament_tour_id: @tour.id, player_id: player[:player_id]).first
        player[:tournament_players_team_name_id] = team.try(:tournament_players_team_name_id)
      end
      @total_group = @team_result_array.group_by { |d| d[:tournament_players_team_name_id] }
      @total_group.each do |e|
        @final_team << e[1].first.merge(e[1].last) do |_, h1, h2|
          if h1.class == String
            h1 == h2 ? h1 : h1 + ' ' + h2
          else
            h1 + h2
          end
        end
      end
      @final_team = @final_team.sort_by { |hsh| hsh[:rating] }.reverse!
    end
  end
end
