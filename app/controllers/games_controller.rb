class GamesController < ApplicationController
  before_action :authenticate_admin!, only: [:create_game]

  # Список всех игр
  def index
    # hardcode
    @games = Game.current_season.order(number: :desc)
  end

  ####### studliga need to remove all this shit! ######
  def studliga

  end

  # TODO: players rating duplicate
  def studliga_rating
    @result_array = []
    object = {}
    # TODO: очень быдловское решение, если не исправлю - будет стыдно
    # players_points_count = GamePlayer.group(:player_id)
    #                            .sum(:points)
    players_points_count = GamePlayer.joins(:game).where('games.students_league = true').group(:player_id).sum(:points)
    # players_penalty_amount = GamePlayer.group(:player_id).sum(:penalty_amount)
    players_points_count.each do |player|
      # game_count = GamePlayer.where(player_id: player[0]).count
      game_count = GamePlayer.joins(:game).where('game_players.player_id = (?)', player[0]).where('games.students_league = true').count

      nick = Player.where(id: player[0]).first
      # object[:penalty_amount] = GamePlayer.where(player_id: player[0]).sum(:penalty_amount)
      object[:penalty_amount] = GamePlayer.joins(:game).where('game_players.player_id = (?)', player[0]).where('games.students_league = true').sum(:penalty_amount)
      # 0.25 - это дополнительный коефициент за колличество игр
      rating = ((player[1] / game_count.to_f) * 100 + object[:penalty_amount] * (-0.5)) + (0.25 * game_count.to_f)
      object[:game_count] = game_count
      object[:nick] = nick.try(:nick)
      object[:rating] = rating
      @result_array << object
      object = {}
    end
    @result_array = @result_array.sort_by { |hsh| hsh[:rating] }.reverse!
    # Получаем колличество игр, которые необходимо сыгать для рейтинга
    game_count = (Game.where(students_league: true).count.to_f / 100) * 20
    position = 1
    # В будущем вынести это в настройки к каждому игроку!!!!!
    banned_nicks = ['Клайд']
    # Чёрный список (временное очень быстрое решение, в будущем переделать!)
    # Так же в это алгоритме используется пересчет мест
    @result_array.each do |player|
      if banned_nicks.include?(player[:nick])
        player[:position] = 'banned'
      else
        # Отыграл 25 процентов игр, или нет
        if player[:game_count] > game_count
          player[:position] = position
          position += 1
        else
          player[:position] = ''
        end
      end
    end
    render template: 'players/players_rating', locals: { studliga: true }
  end

  def studliga_games
    # hardcode
    @games = Game.where(students_league: true).order(date: :desc)
    render action: 'index'
  end
  ############# end ##########################

  def show_game
    @game = Game.find(params[:id])
    @player_of_the_game = GamePlayer.where(game_id: @game.id).order(:table_number)
    @best_game_move = BestGameMove.where(game_id: @game.id)
    @best_game_move_numbers = '( '
    @best_game_move.each do |best_game_move|
      pl = GamePlayer.where(game_id: @game.id, player_id: best_game_move.player_id).first
      @best_game_move_numbers << (pl.try(:table_number).to_s + ' ')
    end
    @best_game_move_numbers += ')'
    @mini_tournaments = MiniTournament.all
    @mafia_stars_tours = BigTournamentTour.all # TODO: обязательно это исправить


  end

  def create_game
    students_league = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:students_league])
    double_points = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:double_points])
    season_id = Season.current_season.id unless students_league # хардкод для сезона
    # Создаем игру со всеми ее параметрами
    # TODO: создать для каждой лиги настройки, в которых будет храниться игра (что бы понимать номер)
    if params[:game_id].present?
      game = Game.where(id: params[:game_id]).first
      game.update(game_params.merge(students_league: students_league, season_id: season_id))
      # Создание игроков игры
      if params[:game_players].present?
        GamePlayer.where(game_id: game.id).destroy_all
        params[:game_players].each do |player|
          GamePlayer.create(game_id: game.id, player_id: player[1][:player_id], role: player[1][:role], remark: player[1][:remark], table_number: player[1][:table_number], penalty_amount: player[1][:penalty_amount])
        end
      end
      if params[:best_game_move].present?
        BestGameMove.where(game_id: game.id).destroy_all
        params[:best_game_move].each do |best_game_move|
          BestGameMove.create(game_id: game.id, player_id: best_game_move)
        end
      end
    else
      if game = Game.create(game_params.merge(students_league: students_league, double_points: double_points, season_id: season_id))
        if params[:best_game_move].present?
          params[:best_game_move].each do |best_game_move|
            BestGameMove.create(game_id: game.id, player_id: best_game_move)
          end
        end
        # Создание игроков игры
        if params[:game_players].present?
          params[:game_players].each do |player|
            GamePlayer.create(game_id: game.id, player_id: player[1][:player_id], role: player[1][:role], remark: player[1][:remark].to_i, table_number: player[1][:table_number], penalty_amount: player[1][:penalty_amount])
          end
        end
      end
    end
    # Обработка очков первоубиенного (возможно в будущем сделать как-то иначе)
    # TODO: есть такой же метод, его нужно объеденить, либо сделать решение лучше, мб в будущем вынести это в сам процесс подсчета
    if pl = GamePlayer.where(player_id: params[:killed_first_id], game_id: game.id).first
      best_player_move_count = pl.best_move
      best_player_move_count *= 2 if pl.game.double_points
      total = pl.points + best_player_move_count
      pl.update_attribute(:points, total) unless best_player_move_count == 0
    end

    if params[:big_tournament_tour_id].present?
      redirect_link = "/show_game/#{game.id}/?tournament=ms"
    else
      redirect_link = "/show_game/#{game.id}"
    end
    render json: { status: 200, message: 'success', link: redirect_link }
  end

  private

  def game_params
    params.permit(:date, :leading_id, :victory, :killed_first_id, :best_player_table_id, :best_player_leading_id, :best_player_leading1_id, :best_player_leading2_id, :comment, :mini_tournament_id, :number, :big_tournament_tour_id)
  end

end
# TODO: возможно в будущем, лучший ход сделать как постгрес аррей, но это не приоритетно