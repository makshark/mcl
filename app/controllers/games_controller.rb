class GamesController < ApplicationController
  before_action :authenticate_admin!, only: [:create_game]
  # TODO: обязательно подобавлять по 0.25 за все игры
  # TODO: посмотреть пример с транзакциейв аутсорс пипл и сделать все это действие транзакцией
  # Список всех игр
  def index
    @games = Game.all
  end

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

  end

  def create_game
    # Создаем игру со всеми ее параметрами
    # TODO: создать для каждой лиги настройки, в которых будет храниться игра (что бы понимать номер)
    if params[:game_id].present?
      game = Game.where(id: params[:game_id]).first
      game.update(game_params)
      # Создание игроков игры
      if params[:game_players].present?
        GamePlayer.where(game_id: game.id).destroy_all
        params[:game_players].each do |player|
          GamePlayer.create(game_id: game.id, player_id: player[1][:player_id], role: player[1][:role], remark: player[1][:remark], table_number: player[1][:table_number])
        end
      end
      if params[:best_game_move].present?
        BestGameMove.where(game_id: game.id).destroy_all
        params[:best_game_move].each do |best_game_move|
          BestGameMove.create(game_id: game.id, player_id: best_game_move)
        end
      end
    else
      if game = Game.create(game_params)
        if params[:best_game_move].present?
          params[:best_game_move].each do |best_game_move|
            BestGameMove.create(game_id: game.id, player_id: best_game_move)
          end
        end
        # Создание игроков игры
        if params[:game_players].present?
          params[:game_players].each do |player|
            GamePlayer.create(game_id: game.id, player_id: player[1][:player_id], role: player[1][:role], remark: player[1][:remark], table_number: player[1][:table_number])
          end
        end
      end
    end
    # Обработка очков первоубиенного (возможно в будущем сделать как-то иначе)
    # TODO: есть такой же метод, его нужно объеденить, либо сделать решение лучше, мб в будущем вынести это в сам процесс подсчета
    if pl = GamePlayer.where(player_id: params[:killed_first_id], game_id: game.id).first
      best_player_move_count = pl.best_move
      total = pl.points + best_player_move_count
      pl.update_attribute(:points, total) unless best_player_move_count == 0
    end

    render json: {status: 200, message: 'success', link: "/show_game/#{game.id}" }
  end

  private

  def game_params
    params.permit(:date, :leading_id, :victory, :killed_first_id, :best_player_table_id, :best_player_leading_id, :comment, :mini_tournament_id)
  end

end
# TODO: возможно в будущем, лучший ход сделать как постгрес аррей, но это не приоритетно